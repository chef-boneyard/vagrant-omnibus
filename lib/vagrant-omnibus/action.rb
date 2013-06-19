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

require "vagrant-omnibus/action/install_chef"

module VagrantPlugins
  module Omnibus
    module Action
      def self.install_chef
        @install_chef ||= ::Vagrant::Action::Builder.new.tap do |b|
          b.use ::Vagrant::Action::Builtin::ConfigValidate
          b.use InstallChef
        end
      end
    end
  end
end
