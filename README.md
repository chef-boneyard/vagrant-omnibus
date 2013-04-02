# vagrant-omnibus

A Vagrant plugin that ensures the desired version of Chef is installed via the
platform-specific Omnibus packages. This proves very useful when using Vagrant
with provisioner-less baseboxes OR cloud images.

## Installation

Ensure you have downloaded and installed Vagrant 1.1.x from the
[Vagrant downloads page](http://downloads.vagrantup.com/).

Installation is performed in the prescribed manner for Vagrant 1.1 plugins.

```
$ vagrant plugin install vagrant-omnibus
```

## Usage

The Omnibus Vagrant plugin automatically hooks into the Vagrant provisioning
middleware. You specify the version of the Chef Omnibus package you want
installed using the `omnibus.chef_version` config key. The version string
should be a valid Chef release version or `:latest`.

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

  config.omnibus.chef_version = "11.4.0"

  ...

end
```

## Tests

### Unit

Coming soon!

### Acceptance

Currently this repo ships with a set of basic acceptance tests that will:

* Provision a Vagrant instance.
* Attempt to install Chef 11.4.0 using this plugin.
* Perform a very basic chef-solo run to ensure Chef is in fact installed.

The acceptance tests are run with the following Vagrant providers:

* VirtualBox (part of core)
* AWS (ships in [vagrant-aws](https://github.com/mitchellh/vagrant-aws) plugin)

The acceptance tests can be run with:

```
rake test:acceptance
```

And as expected, all acceptance tests only uses provisioner-less baseboxes and
cloud images!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Authors

Seth Chisamore (schisamo@opscode.com)
