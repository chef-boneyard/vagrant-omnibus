begin
  require "vagrant"
rescue LoadError
  raise "The Vagrant Omnibus plugin must be run within Vagrant."
end

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

      def self.provision(hook)

        hook.after(Vagrant::Action::Builtin::Provision, Action.install_chef)
        hook.after(Vagrant::Action::Builtin::Provision, Action.install_prereqs)
        
        # BEGIN workaround
        #
        # Currently hooks attached to {Vagrant::Action::Builtin::Provision} are
        # not wired into the middleware return path. My current workaround is to
        # fire after anything boot related which wedges in right before the
        # actual real run of the provisioner.

        hook.after(VagrantPlugins::ProviderVirtualBox::Action::Boot, Action.install_chef)

        if VagrantPlugins.const_defined?("AWS")
          hook.after(VagrantPlugins::AWS::Action::RunInstance, Action.install_chef)
          hook.after(VagrantPlugins::AWS::Action::RunInstance, Action.install_prereqs)
        end

        if VagrantPlugins.const_defined?("Rackspace")
          hook.after(VagrantPlugins::Rackspace::Action::CreateServer, Action.install_chef)
        end

        # END workaround
      end

      action_hook(:install_prereqs, :machine_action_up, &method(:provision))
      action_hook(:install_prereqs, :machine_action_provision, &method(:provision))
      
      action_hook(:install_chef, :machine_action_up, &method(:provision))
      action_hook(:install_chef, :machine_action_provision, &method(:provision))

      
      config(:omnibus) do
        require_relative "config"
        Config
      end
    end
  end
end
