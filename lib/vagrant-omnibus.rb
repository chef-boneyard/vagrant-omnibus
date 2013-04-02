require "pathname"
require "vagrant-omnibus/plugin"

module VagrantPlugins
  module Omnibus
    autoload :Action, 'vagrant-omnibus/action'
    autoload :Config, 'vagrant-omnibus/config'
  end
end
