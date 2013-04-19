require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'

YARD::Rake::YardocTask.new

namespace :test do

  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "test/unit/**/*_spec.rb"
  end

  desc "Run acceptance tests..these actually launch Vagrant sessions."
  task :acceptance do

    # ensure all required dummy boxen are installed
    %w{ aws rackspace }.each do |provider|
      unless system("vagrant box list | grep 'dummy\s*(#{provider})' &>/dev/null")
        system("vagrant box add dummy https://github.com/mitchellh/vagrant-#{provider}/raw/master/dummy.box")
      end
    end

    Dir["test/acceptance/*"].each do |provider_test_dir|

      provider = File.basename(File.expand_path(provider_test_dir))

      puts "=================================================================="
      puts "Running acceptance tests against '#{provider}' provider..."
      puts "=================================================================="

      Dir.chdir("test/acceptance/#{provider}") do
        system("vagrant destroy -f")
        system("vagrant up --provider=#{provider}")
        system("vagrant destroy -f")
      end
    end
  end
end
