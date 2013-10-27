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

require "log4r"
require 'shellwords'

require "vagrant/util/downloader"

module VagrantPlugins
  module Omnibus
    module Action
      # @author Seth Chisamore <schisamo@opscode.com>
      #
      # This action installs Chef Omnibus packages at the desired version.
      class InstallChef

        INSTALL_SH = "#{ENV['OMNIBUS_INSTALL_URL'] || 'https://www.opscode.com/chef/install.sh'}"

        def initialize(app, env)
          @app = app
          @logger = Log4r::Logger.new("vagrantplugins::omnibus::action::installchef")
          @machine = env[:machine]
          # Config#finalize! SHOULD be called automatically
          @machine.config.omnibus.finalize!
        end

        def call(env)
          @app.call(env)

          return if !@machine.communicate.ready? || !provision_enabled?(env)

          desired_version = @machine.config.omnibus.chef_version
          unless desired_version.nil?
            if installed_version == desired_version
              env[:ui].info I18n.t('vagrant-omnibus.action.installed', {
                :version => desired_version
              })
            else
              fetch_install_sh(env)
              env[:ui].info I18n.t('vagrant-omnibus.action.installing', {
                :version => desired_version
              })
              install(desired_version, env)
              recover(env)
            end
          end
        end

        private

        def provision_enabled?(env)
          env.fetch(:provision_enabled, true)
        end

        def installed_version
          version = nil
          command = 'echo $(chef-solo --v | awk "{print \\$2}" || "")'
          @machine.communicate.sudo(command) do |type, data|
            version = data.chomp if [:stderr, :stdout].include?(type)
          end
          version
        end

        # Uploads install.sh from Host's Vagrant TMP directory to guest
        # and executes.
        def install(version, env)
          shell_escaped_version = Shellwords.escape(version)

          @machine.communicate.tap do |comm|
            comm.upload(@install_sh_temp_path, "install.sh")
            # TODO - Execute with `sh` once install.sh removes it's bash-isms.
            comm.sudo("bash install.sh -v #{shell_escaped_version} 2>&1") do |type, data|
              if [:stderr, :stdout].include?(type)
                next if data =~ /stdin: is not a tty/
                env[:ui].info(data)
              end
            end
          end
        end

        # Fetches install.sh file to the Host's Vagrant TMP directory.
        #
        # Mostly lifted from:
        #
        #   https://github.com/mitchellh/vagrant/blob/master/lib/vagrant/action/builtin/box_add.rb
        #
        def fetch_install_sh(env)
          @install_sh_temp_path = env[:tmp_path].join(Time.now.to_i.to_s + "-install.sh")
          @logger.info("Downloading install.sh to: #{@install_sh_temp_path}")

          url = INSTALL_SH
          if File.file?(url) || url !~ /^[a-z0-9]+:.*$/i
            @logger.info("URL is a file or protocol not found and assuming file.")
            file_path = File.expand_path(url)
            file_path = Vagrant::Util::Platform.cygwin_windows_path(file_path)
            url = "file:#{file_path}"
          end

          downloader_options = {}
          # downloader_options[:insecure] = env[:box_download_insecure]
          # downloader_options[:ui] = env[:ui]

          # Download the install.sh file to a temporary path. We store
          # the temporary path as an instance variable so that the
          # `#recover` method can access it.
          begin
            downloader = Vagrant::Util::Downloader.new(url,
                                                       @install_sh_temp_path,
                                                       downloader_options)
            downloader.download!
          rescue Vagrant::Errors::DownloaderInterrupted
            # The downloader was interrupted, so just return, because that
            # means we were interrupted as well.
            env[:ui].info(I18n.t("vagrant-omnibus.download.interrupted"))
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
