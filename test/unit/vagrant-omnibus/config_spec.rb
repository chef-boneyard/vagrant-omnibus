# We have to use `require_relative` until RSpec 2.14.0. As non-standard RSpec
# default paths are not on the $LOAD_PATH.
#
# More info here:
# https://github.com/rspec/rspec-core/pull/831
#
require_relative '../spec_helper'

describe VagrantPlugins::Omnibus::Config do
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

  describe '#validate' do
    let(:machine) { double('machine') }
    let(:error_hash_key) { 'Omnibus Plugin' }
    let(:result) { subject.validate(machine) }
    let(:errors) { result[error_hash_key] }

    it 'returns a Hash with an `Omnibus Plugin` key' do
      result.should be_a(Hash)
      result.should have_key(error_hash_key)
    end

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
              errors.should be_empty
            end
          else
            it 'fails' do
              errors.should_not be_empty
            end
          end
        end
      end
    end # describe chef_version
  end # describe #validate

end
