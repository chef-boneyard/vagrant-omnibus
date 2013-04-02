require "vagrant/action/builder"

module VagrantPlugins
  module Omnibus
    module Action
      autoload :InstallChef, File.expand_path("../action/install_chef", __FILE__)
      autoload :IsRunning, File.expand_path("../action/is_running", __FILE__)
      autoload :ReadChefVersion, File.expand_path("../action/read_chef_version", __FILE__)

      # Include the built-in modules so that we can use them as top-level
      # things.
      include Vagrant::Action::Builtin

      # @return [::Vagrant::Action::Builder]
      def self.install_chef
        @install_chef ||= ::Vagrant::Action::Builder.new.tap do |b|
          b.use ConfigValidate
          b.use Call, IsRunning do |env1, b2|
            if env1[:result]
              b2.use ReadChefVersion
              b2.use InstallChef
              b2.use SSHRun
            end
          end
        end
      end
    end
  end
end
