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
