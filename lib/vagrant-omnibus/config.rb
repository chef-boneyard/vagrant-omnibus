require "vagrant"

module VagrantPlugins
  module Omnibus
    # @author Seth Chisamore <schisamo@opscode.com>
    class Config < Vagrant.plugin("2", :config)

      # @return [String]
      #   The version of Chef to install.
      attr_accessor :chef_version

      def initialize
        @chef_version = UNSET_VALUE
      end

      def finalize!
        @chef_version = nil if @require_chef_version == UNSET_VALUE
      end
    end
  end
end
