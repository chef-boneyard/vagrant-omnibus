require "spec_helper"

describe VagrantPlugins::Omnibus::Plugin do

  context "action hooks" do
    let(:hook) { double(append: true, prepend: true) }
    let(:fake_class) { Class.new }

    it "should hook InstallChef before Provision" do
      stub_const("VagrantPlugins::Omnibus::Action::InstallChef", fake_class)
      hook_proc = described_class.components.action_hooks[:__all_actions__][0]
      hook = double
      expect(hook).to receive(:after).with(Vagrant::Action::Builtin::Provision, VagrantPlugins::Omnibus::Action::InstallChef)
      hook_proc.call(hook)
    end
  end

  it "should define a config of type :omnibus" do
    default_config = described_class.components.configs[:top].to_hash[:omnibus]
    expect(default_config).to be(VagrantPlugins::Omnibus::Config)
  end

  describe ".check_vagrant_version" do
    before :each do
      stub_const("Vagrant::VERSION", "1.2.3")
    end

    it "accepts single String argument" do
      expect(described_class.check_vagrant_version("~> 1.1")).to be_truthy
      expect(described_class.check_vagrant_version("1.2")).to be_falsey
    end

    it "accepts an Array argument" do
      expect(described_class.check_vagrant_version([">= 1.1", "< 1.3.0.beta"])).to be_truthy
      expect(described_class.check_vagrant_version([">= 1.3"])).to be_falsey
    end

    it "accepts multiple arguments" do
      expect(described_class.check_vagrant_version(">= 1.0", "<= 1.3")).to be_truthy
      expect(described_class.check_vagrant_version("~> 1.2", ">= 1.2.5")).to be_falsey
    end
  end

  describe ".check_vagrant_version!" do
    subject { described_class.check_vagrant_version! }
    let(:requirement) { ">= 1.1.0" }
    let(:err_msg) { /requires Vagrant version #{Regexp.escape(requirement.inspect)}/ }

    before :each do
      stub_const(
        "VagrantPlugins::ProxyConf::Plugin::VAGRANT_VERSION_REQUIREMENT",
        requirement
      )
      stub_const("Vagrant::VERSION", vagrant_version)
      allow($stderr).to receive(:puts)
    end

    context "on too old Vagrant version" do
      let(:vagrant_version) { "1.0.9" }
      it "raises error" do
        expect { subject }.to raise_error(err_msg)
      end
      it "warns as stderr" do
        expect($stderr).to receive(:puts).with(err_msg)
        expect { subject }.to raise_error(err_msg)
      end
    end

    context "on exact required Vagrant version" do
      let(:vagrant_version) { "1.1.0" }
      it "does not raise" do
        expect { subject }.not_to raise_error
      end
    end

    context "on newer Vagrant version" do
      let(:vagrant_version) { "1.3.5" }
      it "does not raise" do
        expect { subject }.not_to raise_error
      end
    end
  end
end
