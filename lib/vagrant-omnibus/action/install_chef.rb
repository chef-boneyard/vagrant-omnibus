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
          # Config#finalize! SHOULD be called automatically
          env[:global_config].omnibus.finalize!
        end

        def call(env)
          desired_chef_version = env[:global_config].omnibus.chef_version

          unless desired_chef_version.nil?
            env[:ui].info("Ensuring Chef is installed at requested version of #{desired_chef_version}.")
            if env[:installed_chef_version] == desired_chef_version
              env[:ui].info("Chef #{desired_chef_version} Omnibus package is already installed...skipping installation.")
            else
              env[:ui].info("Chef #{desired_chef_version} Omnibus package is not installed...installing now.")
              env[:ssh_run_command] = install_chef_command(desired_chef_version)
            end
          end

          @app.call(env)
        end

        private

        def install_chef_command(version=latest)
          <<-INSTALL_OMNIBUS
if command -v wget &>/dev/null; then
  wget -qO- #{INSTALL_SH} | sudo bash -s -- -v #{version}
elif command -v curl &>/dev/null; then
  curl -L #{INSTALL_SH} -v #{version} | sudo bash
else
  echo "Neither wget nor curl found. Please install one and try again." >&2
  exit 1
fi
INSTALL_OMNIBUS
        end
      end
    end
  end
end
