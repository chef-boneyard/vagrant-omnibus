module VagrantPlugins
  module Omnibus
    module Action
      # @author Mitchell Hashimoto <mitchell.hashimoto@gmail.com>
      # @author Seth Chisamore <schisamo@opscode.com>
      #
      # This action checks if the machine is up and running.
      #
      # This is a direct copy of
      # `VagrantPlugins::ProviderVirtualBox::Action::IsRunning` that is part of
      # the VirtualBox provider that ships in core Vagrant.
      #
      # @todo find out why this isn't part of `Vagrant::Action::Builtin`
      class IsRunning
        def initialize(app, env)
          @app = app
        end

        def call(env)
          # Set the result to be true if the machine is running.
          env[:result] = env[:machine].state.id == :running

          # Call the next if we have one (but we shouldn't, since this
          # middleware is built to run with the Call-type middlewares)
          @app.call(env)
        end
      end
    end
  end
end
