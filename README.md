# vagrant-omnibus

## Deprecation Warning

This is no longer an actively maintained Chef project. We believe that Test Kitchen offers a far superior development and testing experience as it allows fine grained control of versions, better platform support, and and overall better experience. If this project works for you that's great, but we'd highly suggest using https://kitchen.ci/ instead.

---

[![Gem Version](https://badge.fury.io/rb/vagrant-omnibus.svg)](https://rubygems.org/gems/vagrant-omnibus) [![Build Status](https://travis-ci.org/chef/vagrant-omnibus.svg?branch=master)](https://travis-ci.org/chef/vagrant-omnibus) [![Code Climate](https://codeclimate.com/github/chef/vagrant-omnibus.svg)](https://codeclimate.com/github/chef/vagrant-omnibus)

A Vagrant plugin that ensures the desired version of Chef is installed via the platform-specific Omnibus packages. This proves very useful when using Vagrant with provisioner-less baseboxes OR cloud images.

The plugin should work correctly with most all providers that hook into `Vagrant::Action::Builtin::Provision` for provisioning and is known to work with the following [Vagrant providers](https://www.vagrantup.com/docs/providers/index.html):

- VirtualBox (part of core)
- AWS (ships in [vagrant-aws](https://github.com/mitchellh/vagrant-aws) plugin)
- Rackspace (ships in [vagrant-rackspace](https://github.com/mitchellh/vagrant-rackspace) plugin)
- VMWare Fusion (can be [purchased from Hashicorp](https://www.vagrantup.com/vmware/))
- LXC (ships in [vagrant-lxc](https://github.com/fgrehm/vagrant-lxc))
- OpenStack (ships in [vagrant-openstack-plugin](https://github.com/cloudbau/vagrant-openstack-plugin))
- DigitalOcean (ships in [vagrant-digitalocean](https://github.com/smdahlen/vagrant-digitalocean))
- Parallels Desktop (ships in [vagrant-parallels](https://github.com/yshahin/vagrant-parallels))
- Linode (ships in [vagrant-linode](https://github.com/displague/vagrant-linode))

## Installation

Ensure you have downloaded and installed Vagrant 1.1 or newer from the [Vagrant downloads page](https://www.vagrantup.com/downloads.html). If you require Windows support then Vagrant 1.6.1 or newer is needed.

Installation is performed in the prescribed manner for Vagrant 1.1 plugins.

```
$ vagrant plugin install vagrant-omnibus
```

## Usage

The Omnibus Vagrant plugin automatically hooks into the Vagrant provisioning middleware. You specify the version of the Chef Omnibus package you want installed using the `omnibus.chef_version` config key. The version string should be a valid Chef release version or `:latest`.

Install the latest version of Chef:

```ruby
Vagrant.configure("2") do |config|

  config.omnibus.chef_version = :latest

  ...

end
```

Install a specific version of Chef:

```ruby
Vagrant.configure("2") do |config|

  config.omnibus.chef_version = "14.2.0"

  ...

end
```

Specify a custom install script:

```ruby
Vagrant.configure("2") do |config|

  config.omnibus.install_url = 'http://acme.com/install.sh'
  # config.omnibus.install_url = 'http://acme.com/install.msi'
  # config.omnibus.install_url = '/some/path/on/the/host'

  ...

end
```

If [vagrant-cachier](https://github.com/fgrehm/vagrant-cachier) is present and `config.cache.auto_detect` enabled the downloaded omnibus packages will be cached by vagrant-cachier. In case you want to turn caching off:

```ruby
Vagrant.configure("2") do |config|

  config.omnibus.cache_packages = false

  ...

end
```

This plugin is also multi-vm aware so it would possible to say install a different version of Chef on each VM:

```ruby
Vagrant.configure("2") do |config|

  config.vm.define :new_chef do |new_chef_config|

    ...

    new_chef_config.omnibus.chef_version = :latest

    ...

  end

  config.vm.define :old_chef do |old_chef_config|

    ...

    old_chef_config.omnibus.chef_version = "13.9.1"

    ...

  end
end
```

## Tests

### Unit

The unit tests can be run with:

```
rake test:unit
```

The test are also executed by Travis CI every time code is pushed to GitHub.

### Acceptance

Currently this repo ships with a set of basic acceptance tests that will:

- Provision a Vagrant instance.
- Attempt to install Chef using this plugin.
- Perform a very basic chef-solo run to ensure Chef is in fact installed.

The acceptance tests can be run against a subset of the Vagrant providers listed above. The acceptance tests can be run with:

```
rake test:acceptance:PROVIDER_NAME
```

And as expected, all acceptance tests only uses provisioner-less baseboxes and cloud images!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

Seth Chisamore (schisamo@chef.io)
