# We have to use `require_relative` until RSpec 2.14.0. As non-standard RSpec
# default paths are not on the $LOAD_PATH.
#
# More info here:
# https://github.com/rspec/rspec-core/pull/831
#
require_relative '../spec_helper'

# rubocop:disable LineLength

describe VagrantPlugins::Omnibus::Config do
  let(:machine) { double('machine') }
  let(:instance) { described_class.new }

  subject(:config) do
    instance.tap do |o|
      o.chef_version = chef_version if defined?(chef_version)
      o.finalize!
    end
  end

  describe 'defaults' do
    its(:chef_version) { should be_nil }
  end

  describe 'resolving `:latest` to a real Chef version' do
    let(:chef_version) { :latest }
    its(:chef_version) { should be_a(String) }
    its(:chef_version) { should match(/\d*\.\d*\.\d*/) }
  end

  describe 'validate' do
    it 'should be no-op' do
      expect(subject.validate(machine)).to eq('VagrantPlugins::Omnibus::Config' => [])
    end
  end

  describe '#validate!' do
    describe 'chef_version validation' do
      {
        '11.4.0' => {
          description: 'valid Chef version string',
          valid: true
        },
        '10.99.99' => {
          description: 'invalid Chef version string',
          valid: false
        },
        'FUFUFU' => {
          description: 'invalid RubyGems version string',
          valid: false
        }
      }.each_pair do |version_string, opts|
        context "#{opts[:description]}: #{version_string}" do
          let(:chef_version) { version_string }
          if opts[:valid]
            it 'passes' do
              expect { subject.validate!(machine) }.to_not raise_error
            end
          else
            it 'fails' do
              expect { subject.validate!(machine) }.to raise_error(Vagrant::Errors::ConfigInvalid)
            end
          end
        end
      end
    end # describe chef_version

    describe 'not specified chef_version validation' do
      it 'passes' do
        Gem::DependencyInstaller.any_instance.stub(:find_gems_with_sources).and_return([])
        expect { subject.validate!(machine) }.to_not raise_error
      end
    end # describe not specified chef_version validation

  end # describe #validate
end
