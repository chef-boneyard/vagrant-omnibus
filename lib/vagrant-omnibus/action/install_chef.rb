#
# Copyright (c) 2013, Seth Chisamore
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'log4r'
require 'shellwords'

require 'vagrant/util/downloader'

module VagrantPlugins
  module Omnibus
    module Action
      # @author Seth Chisamore <schisamo@opscode.com>
      #
      # This action installs Chef Omnibus packages at the desired version.
      class InstallChef
        def initialize(app, env)
          @app = app
          @logger =
            Log4r::Logger.new('vagrantplugins::omnibus::action::installchef')
          @machine = env[:machine]
          @install_sh = ENV['OMNIBUS_INSTALL_URL'] ||
            'https://www.opscode.com/chef/install.sh'
          @local_install_name = 'install.sh'
          if windows_guest?
            @local_install_name = 'install.bat'
            chef_version = @machine.config.omnibus.chef_version
            @install_sh = ENV['OMNIBUS_INSTALL_URL'] ||
                windows_chef_url(chef_version)
            @logger.info("Chef windows installer \
                         will be taken from: #{@install_sh}")
          end
          # Config#finalize! SHOULD be called automatically
          @machine.config.omnibus.finalize!
        end

        def call(env)
          @app.call(env)

          return if !@machine.communicate.ready? ||
                    !provision_enabled?(env)

          desired_version = @machine.config.omnibus.chef_version
          unless desired_version.nil?
            if installed_version == desired_version
              env[:ui].info I18n.t(
                'vagrant-omnibus.action.installed',
                version: desired_version
              )
            else
              fetch_install_sh(env)
              env[:ui].info I18n.t(
                'vagrant-omnibus.action.installing',
                version: desired_version
              )
              install(desired_version, env)
              recover(env)
            end
          end
        end

        private

        def windows_chef_url(chef_version)
          # create URL to get desired chef version
          # adapted from https://github.com/opscode/knife-windows/blob/
          # master/lib/chef/knife/bootstrap/windows-chef-client-msi.erb
          windows_version = /Version (?<major_minor>\d+\.\d+)\.(?<build>\d+)/
                            .match(`cmd /c ver`)
          case windows_version[:major_minor]
          when '5.2'
            machine_os = '2003r2'
          when '6.0'
            machine_os = '2008'
          when '6.1'
            machine_os = '2008r2'
          when '6.2', '6.3'
            machine_os = '2012'
          else
            machine_os = '2008r2'
          end
          # detect architecture
          windows_arch = ENV['PROCESSOR_ARCHITEW6432'] ||
              ENV['PROCESSOR_ARCHITECTURE']
          case windows_arch.downcase
          when 'amd64'
            machine_arch = 'x86_64'
          else
            machine_arch = 'i686'
          end
          "https://www.opscode.com/chef/download?p=windows&pv=#{machine_os}&m=#{machine_arch}&v=#{chef_version}"
        end

        def windows_guest?
          @machine.config.vm.guest.eql?(:windows)
        end

        def provision_enabled?(env)
          env.fetch(:provision_enabled, true)
        end

        def installed_version
          version = nil
          opts = nil
          if windows_guest?
            command = 'cmd.exe /c chef-solo -v 2>&0'
            opts = { shell: :cmd, error_check: false }
          else
            command = 'echo $(chef-solo -v)'
          end
          @machine.communicate.sudo(command, opts) do |type, data|
            if [:stderr, :stdout].include?(type)
              next if data =~ /stdin: is not a tty/
              v = data.chomp
              version ||= v.split[1] unless v.empty?
            end
          end
          version
        end

        # Uploads install.sh|bat from Host's Vagrant TMP directory to guest
        # and executes.
        def install(version, env)
          shell_escaped_version = Shellwords.escape(version)

          @machine.communicate.tap do |comm|
            comm.upload(@install_sh_temp_path, @local_install_name)
            if windows_guest?
              install_cmd = "cmd.exe /c #{@local_install_name}"
            else
              # TODO: Execute with `sh` once install.sh removes it's bash-isms.
              install_cmd = "bash #{@local_install_name} \
                            -v #{shell_escaped_version} 2>&1"
            end
            comm.sudo(install_cmd) do |type, data|
              if [:stderr, :stdout].include?(type)
                next if data =~ /stdin: is not a tty/
                env[:ui].info(data)
              end
            end
          end
        end

        # Fetches install.sh or creates install.bat file
        # to the Host's Vagrant TMP directory.
        #
        # Mostly lifted from:
        #
        #   mitchellh/vagrant/blob/master/lib/vagrant/action/builtin/box_add.rb
        #
        def fetch_install_sh(env)
          @install_sh_temp_path =
            env[:tmp_path].join(Time.now.to_i.to_s + "-#{@local_install_name}")
          @logger.info("Downloading #{@local_install_name} to:
                       #{@install_sh_temp_path}")
          url = @install_sh
          if File.file?(url) || url !~ /^[a-z0-9]+:.*$/i
            @logger.info('Assuming URL is a file.')
            file_path = File.expand_path(url)
            file_path = Vagrant::Util::Platform.cygwin_windows_path(file_path)
            url = "file:#{file_path}"
          end

          downloader_options = {}
          # downloader_options[:insecure] = env[:box_download_insecure]
          # downloader_options[:ui] = env[:ui]

          # Download the install.sh or create install.bat file
          # to a temporary path. We store the temporary path as
          # an instance variable so that the `#recover` method can access it.
          begin
            if windows_guest?
              # create install.bat file in @install_sh_temp_path location
              File.open(@install_sh_temp_path, 'w') do |f|
                f.puts <<-eos
                @echo off
                set dest=%~dp0\install.msi
                echo "Downloading Chef from #{url} to %dest%"
                powershell -command "(New-Object System.Net.WebClient).DownloadFile('#{url}', '%dest%')"
                echo Running installation %dest%
                msiexec /q /i %dest%
                eos
              end
            else
              downloader = Vagrant::Util::Downloader.new(url,
                                                         @install_sh_temp_path,
                                                         downloader_options)
              downloader.download!
            end
          rescue Vagrant::Errors::DownloaderInterrupted
            # The downloader was interrupted, so just return, because that
            # means we were interrupted as well.
            env[:ui].info(I18n.t('vagrant-omnibus.download.interrupted'))
            return
          end
        end

        def recover(env)
          if @install_sh_temp_path && File.exist?(@install_sh_temp_path)
            File.unlink(@install_sh_temp_path)
          end
        end
      end
    end
  end
end
