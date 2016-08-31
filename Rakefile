require "bundler/setup"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "chefstyle"
require "rubocop/rake_task"
require "yard"

# rubocop:disable LineLength

def run_acceptance_tests(provider = "virtualbox")
  puts "=================================================================="
  puts "Running acceptance tests against '#{provider}' provider..."
  puts "=================================================================="

  Dir.chdir("test/acceptance/#{provider}") do
    system("vagrant destroy -f")
    system("vagrant up --provider=#{provider}")
    system("vagrant destroy -f")
  end
end

YARD::Rake::YardocTask.new

namespace :style do
  desc "Run Ruby style checks"
  RuboCop::RakeTask.new(:ruby) do |task|
    task.patterns = [
      "**/*.rb",
      "**/Vagrantfile",
      "*.gemspec",
      "Gemfile",
      "Rakefile",
    ]
  end
end

namespace :test do

  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "test/unit/**/*_spec.rb"
  end

  namespace :acceptance do
    desc "Run acceptance tests with AWS provider"
    task :aws do
      unless system("vagrant box list | grep 'dummy\s*(aws)' &>/dev/null")
        system("vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box")
      end
      run_acceptance_tests("aws")
    end

    desc "Run acceptance tests with Digital Ocean provider"
    task "digital_ocean" do
      unless system("vagrant box list | grep 'digital_ocean' &>/dev/null")
        system("vagrant box add digital_ocean https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box")
      end
      run_acceptance_tests("digital_ocean")
    end

    desc "Run acceptance tests with Rackspace provider"
    task :rackspace do
      unless system("vagrant box list | grep 'dummy\s*(rackspace)' &>/dev/null")
        system("vagrant box add dummy https://github.com/mitchellh/vagrant-rackspace/raw/master/dummy.box")
      end
      run_acceptance_tests("rackspace")
    end

    desc "Run acceptance tests with VirtualBox provider"
    task :virtualbox do
      run_acceptance_tests("virtualbox")
    end

    desc "Run acceptance tests with VMware provider"
    task :vmware_fusion do
      run_acceptance_tests("vmware_fusion")
    end
  end
end

# We cannot run Test Kitchen on Travis CI yet...
namespace :travis do
  desc "Run tests on Travis"
  task ci: ["style:ruby", "test:unit"]
end

require "vagrant-omnibus/version"
require "github_changelog_generator/task"

GitHubChangelogGenerator::RakeTask.new :changelog do |config|
  config.issues = false
  config.future_release = VagrantPlugins::Omnibus::VERSION
  config.enhancement_labels = "enhancement,Enhancement,New Feature".split(",")
  config.bug_labels = "bug,Bug,Improvement,Upstream Bug".split(",")
  config.exclude_labels = "duplicate,question,invalid,wontfix,no_changelog,Exclude From Changelog".split(",")
end

# The default rake task should just run it all
task default: ["style:ruby", "test:unit", "test:acceptance:virtualbox"]
