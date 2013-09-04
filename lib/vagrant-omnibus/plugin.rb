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

# This is a sanity check to make sure no one is attempting to install
# this into an early Vagrant version.
if Vagrant::VERSION < "1.1.0"
  raise "The Vagrant Omnibus plugin is only compatible with Vagrant 1.1+"
end

module VagrantPlugins
  module Omnibus
    # @author Seth Chisamore <schisamo@opscode.com>
    class Plugin < Vagrant.plugin("2")
      name "Omnibus"
      description <<-DESC
      This plugin ensures the desired version of Chef is installed
      via the platform-specific Omnibus packages.
      DESC

      action_hook(:install_chef, Plugin::ALL_ACTIONS) do |hook|
        require_relative "action/install_chef"
        hook.after(Vagrant::Action::Builtin::Provision, Action::InstallChef)

        # The AWS provider uses a non-standard Provision action on initial
        # creation:
        #
        # https://github.com/mitchellh/vagrant-aws/blob/master/lib/vagrant-aws/action.rb#L105
        #
        if VagrantPlugins.const_defined?("AWS")
          hook.after(VagrantPlugins::AWS::Action::TimedProvision, Action::InstallChef)
        end
      end

      config(:omnibus) do
        require_relative "config"
        Config
      end
    end
  end
end
