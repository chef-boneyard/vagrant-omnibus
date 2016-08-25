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
  #
  module Omnibus
    # @author Seth Chisamore <schisamo@chef.io>
    class Plugin < Vagrant.plugin("2")
      name "vagrant-omnibus"
      description <<-DESC
      This plugin ensures the desired version of Chef is installed
      via the platform-specific Omnibus packages.
      DESC

      VAGRANT_VERSION_REQUIREMENT = ">= 1.1.0"

      # Returns true if the Vagrant version fulfills the requirements
      #
      # @param requirements [String, Array<String>] the version requirement
      # @return [Boolean]
      def self.check_vagrant_version(*requirements)
        Gem::Requirement.new(*requirements).satisfied_by?(
          Gem::Version.new(Vagrant::VERSION)
        )
      end

      # Verifies that the Vagrant version fulfills the requirements
      #
      # @raise [VagrantPlugins::Omnibus::VagrantVersionError] if this plugin
      # is incompatible with the Vagrant version
      def self.check_vagrant_version!
        unless check_vagrant_version(VAGRANT_VERSION_REQUIREMENT)
          msg = I18n.t(
            "vagrant-omnibus.errors.vagrant_version",
            requirement: VAGRANT_VERSION_REQUIREMENT.inspect
          )
          $stderr.puts(msg)
          raise msg
        end
      end

      action_hook(:install_chef, Plugin::ALL_ACTIONS) do |hook|
        require_relative "action/install_chef"
        hook.after(Vagrant::Action::Builtin::Provision, Action::InstallChef)

        # The AWS provider < v0.4.0 uses a non-standard Provision action
        # on initial creation:
        #
        # mitchellh/vagrant-aws/blob/v0.3.0/lib/vagrant-aws/action.rb#L105
        #
        if defined? VagrantPlugins::AWS::Action::TimedProvision
          hook.after(
            VagrantPlugins::AWS::Action::TimedProvision,
            Action::InstallChef
          )
        end
      end

      config(:omnibus) do
        require_relative "config"
        Config
      end
    end
  end
end
