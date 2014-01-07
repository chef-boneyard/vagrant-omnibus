require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'

YARD::Rake::YardocTask.new

Rubocop::RakeTask.new(:rubocop) do |task|
  task.patterns = [
    '**/*.rb',
    '**/Vagrantfile',
    '*.gemspec',
    'Gemfile',
    'Rakefile'
  ]
end

namespace :test do

  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "test/unit/**/*_spec.rb"
  end

  desc "Run acceptance tests..these actually launch Vagrant sessions."
  task :acceptance, :provider do |t, args|

    # ensure all required dummy boxen are installed
    %w{ aws rackspace }.each do |provider|
      unless system("vagrant box list | grep 'dummy\s*(#{provider})' &>/dev/null")
        system("vagrant box add dummy https://github.com/mitchellh/vagrant-#{provider}/raw/master/dummy.box")
      end
    end

    unless system("vagrant box list | grep 'digital_ocean' &>/dev/null")
      system("vagrant box add digital_ocean https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box")
    end

    all_providers = Dir["test/acceptance/*"].map{|dir| File.basename(File.expand_path(dir))}

    # If a provider wasn't passed to the task run acceptance tests against
    # ALL THE PROVIDERS!
    providers = if args[:provider] && all_providers.include?(args[:provider])
                  [args[:provider]]
                else
                  all_providers
                end

    providers.each do |provider|
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
