require "spec_helper"

# rubocop:disable LineLength

describe VagrantPlugins::Omnibus::Config do
  let(:machine) { double("machine") }
  let(:instance) { described_class.new }

  subject(:config) do
    instance.tap do |o|
      o.chef_version = chef_version if defined?(chef_version)
      o.install_url = install_url if defined?(install_url)
      o.cache_packages = cache_packages if defined?(cache_packages)
      o.finalize!
    end
  end

  context "default values" do
    describe "#chef_version" do
      subject { super().chef_version }
      it { is_expected.to be_nil }
    end

    describe "#install_url" do
      subject { super().install_url }
      it { is_expected.to be_nil }
    end

    describe "#cache_packages" do
      subject { super().cache_packages }
      it { is_expected.to be_truthy }
    end
  end

  describe "no longer resolves :latest to a Chef version" do
    let(:chef_version) { :latest }

    describe "#chef_version" do
      subject { super().chef_version }
      it { is_expected.to eql(:latest) }
    end
  end

  describe "setting a custom `install_url`" do
    let(:install_url) { "http://some_path.com/install.sh" }

    describe "#install_url" do
      subject { super().install_url }
      it { is_expected.to eq("http://some_path.com/install.sh") }
    end
  end

  describe "the `cache_packages` config option behaves truthy" do
    [true, "something", :cachier].each do |obj|
      describe "when `#{obj}` (#{obj.class})" do
        let(:cache_packages) { obj }

        describe "#cache_packages" do
          subject { super().cache_packages }
          it { is_expected.to be_truthy }
        end
      end
    end
    [nil, false].each do |obj|
      describe "when `#{obj}` (#{obj.class})" do
        let(:cache_packages) { obj }

        describe "#cache_packages" do
          subject { super().cache_packages }
          it { is_expected.to be_falsey }
        end
      end
    end
  end

  describe "validate" do
    it "is a be no-op" do
      expect(subject.validate(machine)).to eq("VagrantPlugins::Omnibus::Config" => [])
    end
  end

  describe "#validate!" do
    describe "chef_version validation" do
      {
        "11.4.0" => {
          description: "valid Chef version string",
          valid: true,
        },
        "10.99.99" => {
          description: "invalid Chef version string",
          valid: false,
        },
        "FUFUFU" => {
          description: "invalid RubyGems version string",
          valid: false,
        },
      }.each_pair do |version_string, opts|
        context "#{opts[:description]}: #{version_string}" do
          let(:chef_version) { version_string }
          if opts[:valid]
            it "passes" do
              expect { subject.validate!(machine) }.to_not raise_error
            end
          else
            it "fails" do
              expect { subject.validate!(machine) }.to raise_error(Vagrant::Errors::ConfigInvalid)
            end
          end
        end
      end
    end # describe chef_version

    describe "not specified chef_version validation" do
      it "passes" do
        allow_any_instance_of(Gem::DependencyInstaller).to receive(:find_gems_with_sources).and_return([])
        expect { subject.validate!(machine) }.to_not raise_error
      end
    end # describe not specified chef_version validation

  end # describe #validate
end
