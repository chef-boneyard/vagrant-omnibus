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
          @install_script = find_install_script
          @machine.config.omnibus.finalize!
        end

        def call(env)
          @app.call(env)

          return unless @machine.communicate.ready? && provision_enabled?(env)

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

        # Determines what flavor of install script should be used to
        # install Omnibus Chef package.
        def find_install_script
          if !ENV['OMNIBUS_INSTALL_URL'].nil?
            ENV['OMNIBUS_INSTALL_URL']
          elsif windows_guest?
            'http://www.getchef.com/chef/install.msi'
          else
            'https://www.getchef.com/chef/install.sh'
          end
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
          url = @install_script
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
