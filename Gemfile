source "https://rubygems.org"

gemspec

group :development do
  # We depend on Vagrant for development, but we don't add it as a
  # gem dependency because we expect to be installed within the
  # Vagrant environment itself using `vagrant plugin`.
  gem "vagrant", git: "git://github.com/mitchellh/vagrant.git", tag: "v1.8.4"
  gem "listen", "~> 3.0.8"
end

group :acceptance do
  gem "vagrant-digitalocean", "~> 0.5"
  gem "vagrant-aws", "~> 0.4"
  gem "vagrant-rackspace", "~> 0.1"
  gem "vagrant-linode", "~> 0.2"
end

group :docs do
  gem "yard", "~> 1.8.2"
  gem "redcarpet", "~> 2.2"
  gem "github-markup", "~> 0.7"
end
