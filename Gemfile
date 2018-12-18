source "https://rubygems.org"

gemspec

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", git: "https://github.com/hashicorp/vagrant.git", tag: "v2.1.1"
end

group :acceptance do
  gem "vagrant-digitalocean", "~> 0.5"
  gem "vagrant-aws", "~> 0.4"
  gem "vagrant-rackspace", "~> 0.1"
  gem "vagrant-linode", "~> 0.4"
end

group :docs do
  gem "yard", "~> 0.9.11"
  gem "redcarpet", "~> 2.2"
  gem "github-markup", "~> 0.7"
end
