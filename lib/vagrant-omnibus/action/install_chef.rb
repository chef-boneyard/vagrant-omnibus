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
        end

        def call(env)
          @app.call(env)

          return unless @machine.communicate.ready? && provision_enabled?(env)

          # Perform delayed validation
          @machine.config.omnibus.validate!(@machine)

          desired_version = @machine.config.omnibus.chef_version
          unless desired_version.nil?
            if installed_version == desired_version
              env[:ui].info I18n.t(
                'vagrant-omnibus.action.installed',
                version: desired_version
              )
            else
              fetch_or_create_install_script(env)
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

        # The specific directory to which the omnibus package should be
        # downloaded to on the guest, if any
        def omnibus_download_dir
          ENV['OMNIBUS_DOWNLOAD_DIR']
        end

        def install_script_name
          if windows_guest?
            'install.bat'
          else
            'install.sh'
          end
        end

        def windows_guest?
          @machine.config.vm.guest.eql?(:windows)
        end

        def provision_enabled?(env)
          env.fetch(:provision_enabled, true)
        end

        def communication_opts
          if windows_guest?
            { shell: 'cmd' }
          else
            { shell: 'sh' }
          end
        end

        def installed_version
          version = nil
          opts = communication_opts
          if windows_guest?
            command = 'cmd.exe /c chef-solo -v 2>&0'
            opts[:error_check] = false
          else
            command = 'echo $(chef-solo -v)'
          end
          @machine.communicate.sudo(command, opts) do |type, data|
            if [:stderr, :stdout].include?(type)
              version_match = data.match(/^Chef: (.+)/)
              version = version_match.captures[0].strip if version_match
            end
          end
          version
        end

        #
        # Upload install script from Host's Vagrant TMP directory to guest
        # and executes.
        #
        def install(version, env)
          shell_escaped_version = Shellwords.escape(version)

          @machine.communicate.tap do |comm|
            comm.upload(@script_tmp_path, install_script_name)
            if windows_guest?
              install_cmd = "cmd.exe /c #{install_script_name} #{version}"
            else
              install_cmd = "sh #{install_script_name}"
              install_cmd << " -v #{shell_escaped_version}"
              unless omnibus_download_dir.nil? || omnibus_download_dir.empty?
                install_cmd << " -d #{omnibus_download_dir}"
              end
              install_cmd << ' 2>&1'
            end
            comm.sudo(install_cmd, communication_opts) do |type, data|
              if [:stderr, :stdout].include?(type)
                next if data =~ /stdin: is not a tty/
                env[:ui].info(data)
              end
            end
          end
        end

        #
        # Fetches or creates a platform specific install script to the Host's
        # Vagrant TMP directory.
        #
        def fetch_or_create_install_script(env)
          @script_tmp_path =
            env[:tmp_path].join("#{Time.now.to_i.to_s}-#{install_script_name}")

          @logger.info("Generating install script at: #{@script_tmp_path}")

          url = @install_script

          if File.file?(url) || url !~ /^[a-z0-9]+:.*$/i
            @logger.info('Assuming URL is a file.')
            file_path = File.expand_path(url)
            file_path = Vagrant::Util::Platform.cygwin_windows_path(file_path)
            url = "file:#{file_path}"
          end

          # Download the install.sh or create install.bat file to a temporary
          # path. We store the temporary path as an instance variable so that
          # the `#recover` method can access it.
          begin
            if windows_guest?
              # generate a install.bat file at the `@script_tmp_path` location
              #
              # We'll also disable Rubocop for this embedded PowerShell code:
              #
              # rubocop:disable LineLength, SpaceAroundBlockBraces
              #
              File.open(@script_tmp_path, 'w') do |f|
                f.puts <<-EOH.gsub(/^\s{18}/, '')
                  @echo off
                  set version=%1
                  set dest=%~dp0chef-client-%version%-1.windows.msi
                  echo Downloading Chef %version% for Windows...
                  powershell -command "(New-Object System.Net.WebClient).DownloadFile('#{url}?v=%version%', '%dest%')"
                  echo Installing Chef %version%
                  msiexec /q /i %dest%
                EOH
              end
              # rubocop:enable LineLength, SpaceAroundBlockBraces
            else
              downloader = Vagrant::Util::Downloader.new(
                url,
                @script_tmp_path,
                {}
              )
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
          if @script_tmp_path && File.exist?(@script_tmp_path)
            # Try extra hard to unlink the file so that it reliably works
            # on Windows hosts as well, see:
            # http://alx.github.io/2009/01/27/ruby-wundows-unlink.html
            file_deleted = false
            until file_deleted
              begin
                File.unlink(@script_tmp_path)
                file_deleted = true
              rescue Errno::EACCES
                @logger.debug("failed to unlink #{@script_tmp_path}. retry...")
              end
            end
          end
        end
      end
    end
  end
end
