## 1.0.2 (April 20, 2013)

IMPROVEMENTS:

* Unit test coverage for `VagrantPlugins::Omnibus::Config` ([@schisamo][])
* Add Rackspace provider acceptance test. ([@schisamo][])
* Parameterize the acceptance test Rake task, this allows you test run acceptance tests against a single provider. ([@schisamo][])

BUG FIXES:

* Fixes [#2][]: Convert `Gem::Version` returned by `#retrieve_latest_chef_version` to a string. ([@schisamo][])
* Fixes [#6][]: RubyGems 2.0 compat: use #empty? to check for results. ([@schisamo][])
* Fixes [#7][]: Ensure 'vagrant-rackspace/action' is loaded. ([@schisamo][])
* Fixes [#8][]: Trigger plugin if machine state is `:active`. ([@schisamo][])

## 1.0.1 (April 17, 2013)

IMPROVEMENTS:

* Issue [#2][]: Resolve `latest` to a real Chef version. This ensures the plugin does not attempt to re-install Chef on subsequent provisions. ([@schisamo][])
* Issue [#4][]: Validate user provided value for omnibus.chef_version is in fact a real Chef version. ([@schisamo][])
* Retrieve omnibus.chef_version directly from global config. ([@schisamo][])
* Update development dependencies to vagrant (1.2.1) and vagrant-aws (0.2.1). ([@schisamo][])

BUG FIXES:

* Issue [#3][]: Plugin now correctly operates in "no-op" node if now `omnibus.chef_version` is not present in the Vagrantfile. ([@schisamo][])
* Use Ubuntu 12.04 release AMI for acceptance testing. ([@schisamo][])

## 1.0.0 (April 1, 2013)

* The initial release.
