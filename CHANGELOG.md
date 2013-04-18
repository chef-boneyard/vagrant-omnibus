## 1.0.2 (unreleased)

IMPROVEMENTS:

* unit test coverage for `VagrantPlugins::Omnibus::Config`

BUG FIXES:

* convert `Gem::Version` returned by `#retrieve_latest_chef_version` to a
  string. fixes [GH-2] for realz.

## 1.0.1 (April 17, 2013)

IMPROVEMENTS:

* Resolve `latest` to a real Chef version. This ensures the plugin does not
  attempt to re-install Chef on subsequent provisions. [GH-2]
* Validate user provided value for omnibus.chef_version is in fact a real Chef
  version. [GH-4]
* Retrieve omnibus.chef_version directly from global config.
* Update development depdendencies to vagrant (1.2.1) and vagrant-aws
  (0.2.1).

BUG FIXES:

* Plugin now correctly operates in "no-op" node if now "omnibus.chef_version"
  is not present in the Vagrantfile. [GH-3]
* Use Ubuntu 12.04 release AMI for acceptance testing.

## 1.0.0 (April 1, 2013)

* The initial release.
