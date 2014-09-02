require_relative '../spec_helper'

describe VagrantPlugins::Omnibus::Plugin do

  describe '.check_vagrant_version' do
    before :each do
      stub_const('Vagrant::VERSION', '1.2.3')
    end

    it "accepts single String argument" do
      expect(described_class.check_vagrant_version('~> 1.1')).to be_true
      expect(described_class.check_vagrant_version('1.2')).to be_false
    end

    it "accepts an Array argument" do
      expect(described_class.check_vagrant_version(['>= 1.1', '< 1.3.0.beta'])).to be_true
      expect(described_class.check_vagrant_version(['>= 1.3'])).to be_false
    end

    it "accepts multiple arguments" do
      expect(described_class.check_vagrant_version('>= 1.0', '<= 1.3')).to be_true
      expect(described_class.check_vagrant_version('~> 1.2', '>= 1.2.5')).to be_false
    end
  end

  describe '.check_vagrant_version!' do
    subject { described_class.check_vagrant_version! }
    let(:requirement) { '>= 1.1.0' }
    let(:err_msg) { /requires Vagrant version #{Regexp.escape(requirement.inspect)}/ }

    before :each do
      stub_const(
        'VagrantPlugins::ProxyConf::Plugin::VAGRANT_VERSION_REQUIREMENT',
        requirement)
      stub_const('Vagrant::VERSION', vagrant_version)
      $stderr.stub(:puts)
    end

    context "on too old Vagrant version" do
      let(:vagrant_version) { '1.0.9' }
      it "raises error" do
        expect { subject }.to raise_error(err_msg)
      end
      it "warns as stderr" do
        $stderr.should_receive(:puts).with(err_msg)
        subject rescue nil
      end
    end

    context "on exact required Vagrant version" do
      let(:vagrant_version) { '1.1.0' }
      it "does not raise" do
        expect { subject }.not_to raise_error
      end
    end

    context "on newer Vagrant version" do
      let(:vagrant_version) { '1.3.5' }
      it "does not raise" do
        expect { subject }.not_to raise_error
      end
    end
  end
end