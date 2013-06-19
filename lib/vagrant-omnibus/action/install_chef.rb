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
          @machine = env[:machine]
        end

        def call(env)
          @app.call(env)

          return unless @machine.communicate.ready?

          desired_version = @machine.config.omnibus.chef_version
          unless desired_version.nil?
            if installed_version == desired_version
              env[:ui].info I18n.t('vagrant-omnibus.action.installed', {
                :version => desired_version
              })
            else
              env[:ui].info I18n.t('vagrant-omnibus.action.installing', {
                :version => desired_version
              })
              install(desired_version)
            end
          end
        end

        private

        def installed_version
          version = nil
          command = 'echo $(chef-solo --v | awk "{print \\$2}" || "")'
          @machine.communicate.sudo(command) do |type, data|
            version = data.chomp if [:stderr, :stdout].include?(type)
          end
          version
        end

        def install(version)
          command = <<-INSTALL_OMNIBUS
            if command -v wget &>/dev/null; then
              wget -qO- #{INSTALL_SH} | sudo bash -s -- -v #{version}
            elif command -v curl &>/dev/null; then
              curl -L #{INSTALL_SH} -v #{version} | sudo bash
            else
              echo "Neither wget nor curl found. Please install one." >&2
              exit 1
            fi
          INSTALL_OMNIBUS
          @machine.communicate.sudo(command)
        end
      end
    end
  end
end
