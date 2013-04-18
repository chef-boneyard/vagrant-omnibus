require 'rubygems/dependency'
require 'rubygems/dependency_installer'
require 'vagrant'

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
        if @chef_version == UNSET_VALUE
          @chef_version = nil
        elsif @chef_version.to_s == 'latest'
          # resolve `latest` to a real version
          @chef_version = retrieve_latest_chef_version
        end
      end

      private

      # Query RubyGems.org's Ruby API and retrive the latest version of Chef.
      def retrieve_latest_chef_version
        latest_version = nil

        available_gems = dependency_installer.find_gems_with_sources(chef_gem_dependency)
        spec, source = if available_gems.respond_to?(:last)
                          # DependencyInstaller sorts the results such that the last one is
                          # always the one it considers best.
                          spec_with_source = available_gems.last
                          spec_with_source
                        else
                          # Rubygems 2.0 returns a Gem::Available set, which is a
                          # collection of AvailableSet::Tuple structs
                          available_gems.pick_best!
                          best_gem = available_gems.set.first
                          best_gem && [best_gem.spec, best_gem.source]
                        end

        latest_version = spec && spec.version

        latest_version
      end

      def dependency_installer
        @dependency_installer ||= Gem::DependencyInstaller.new
      end

      def chef_gem_dependency(version=nil)
        Gem::Dependency.new('chef', version)
      end
    end
  end
end
