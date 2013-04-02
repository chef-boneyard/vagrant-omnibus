module VagrantPlugins
  module Omnibus
    module Action
      # @author Seth Chisamore <schisamo@opscode.com>
      #
      # This action will extract the installed version of Chef installed on the
      # guest. The resulting version will exist in the `:installed_chef_version`
      # key in the environment.
      class ReadChefVersion
        def initialize(app, env)
          @app = app
        end

        def call(env)
          env[:installed_chef_version] = nil
          env[:machine].communicate.tap do |comm|
            # Execute it with sudo
            comm.sudo(chef_version_command) do |type, data|
              if [:stderr, :stdout].include?(type)
                env[:installed_chef_version] = data.chomp
              end
            end
          end
          @app.call(env)
        end

        private

        def chef_version_command
          <<-CHEF_VERSION
echo $(chef-solo --v | awk "{print \\$2}" || "")
          CHEF_VERSION
        end
      end
    end
  end
end
