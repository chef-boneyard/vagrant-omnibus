vagrant-omnibus Changelog
=========================
This file is used to list changes made in each version of the vagrant-omnibus plugin.

1.4.1 (April 26, 2014)
----------------------
### Bug Fixes

- Issue [#79][]: Install command not idempotent on Windows. ([@schisamo][])

1.4.0 (April 25, 2014)
-------------------------
### New Features

- PR [#73][]: Full caching of omnibus package downloads! Huge thanks to [@tknerr][] for all all his Herculean effort coordinating this fix in [vagrant-cachier/#13](https://github.com/fgrehm/vagrant-cachier/issues/13) and [opscode-omnitruck/#3](https://github.com/opscode/opscode-omnitruck/pull/33).

### Bug Fixes

- PR [#67][]: No-op validation if `config.omnibus.chef_version` is `nil`. ([@skv-headless][])

1.3.1 (March 12, 2014)
----------------------
### Improvements

- PR [#66][]: Run install.sh with `sh` rather than `bash`. ([@tknerr][])

### Bug Fixes

- PR [#65][]: Make unlinking the install.sh reliably work on windows hosts. ([@tknerr][])
- Issue [#69][]: Ensure all remote commands are executed with `sh`. ([@schisamo][])

1.3.0 (February 24, 2014)
-------------------------
### New Features

- PR [#59][], PR [#60][]: Windows guest support! ([@jarig][])([@schisamo][])

### Improvements

- PR [#61][]: Make detection of currently installed Chef version more robust. ([@ampedandwired][])
- Create explicit tasks for supported provider acceptance tests. ([@schisamo][])
- Add Ruby 2.1.0 to the Travis CI test matrix. ([@schisamo][])

### Bug Fixes

- Issue [#13][]: Perform config validation at action execution time. ([@schisamo][])

1.2.1 (December 17, 2013)
-------------------------
### Improvements

- Acceptance test coverage that verifies Chef is not reinstalled into a system where the desired version of Chef already exists. ([@schisamo][])

### Bug Fixes

- PR [#57][]: Filter `stdin is not a tty` when querying installed Chef version. ([@scalp42][])

1.2.0 (December 17, 2013)
-------------------------
### New Features

- PR [#52][]: Change plugin name to correspond to gem name. ([@tmatilai][])

### Improvements

- PR [#48][]: Don't install Chef if `--no-provision` is specified. ([@tmatilai][])
- PR [#50][]: Update README.md with vagrant-parallels compatibility. ([@wizonesolutions][])
- PR [#56][]: Add Rubocop support and fix style errors. ([@schisamo][])

### Bug Fixes

- Issue [#12][]: Ensure plugin is no-op on Windows guests. ([@schisamo][])
- PR [#53][]: Ensure installed version check works on all platforms. ([@comutt][])

1.1.2 (October 17, 2013)
------------------------
### Improvements

- PR [#41][]: Add vagrant-digitalocean to the list of supported providers. ([@tmatilai][])
- PR [#45][]: Compatibility with vagrant-aws v0.4.0 ([@tmatilai][])
- Use Vagrant's built in `Vagrant::Util::Downloader` class; removes requirement of the
  guest OS having `wget` or `curl` installed. ([@schisamo][])

### Bug Fixes

- PR [#43][]: Fix development dependencies and Travis tests. ([@tmatilai][])
- Issue [#33][] Split fetching of `install.sh` from the actual execution ([@schisamo][])

1.1.1 (September 4, 2013)
-------------------------
### Bug Fixes

- PR [#28][]: Include OpenStack provider into the list of working providers. ([@srenatus][])
- PR [#32][], Issue [#31][]: No need to do sudo in sudo ([@matsu911][])
- PR [#32][], Issue [#32][]: Fix the curl line to install the requested Chef version ([@tmatilai][])
- PR [#37][]: Document that newer than v1.1.x Vagrant is fine, too. ([@tmatilai][])
- PR [#38][]: Drop unneeded ConfigValidate action call ([@tmatilai][])
- Issue [#27][]: Properly shell escape version strings ([@schisamo][])

1.1.0 (June 21, 2013)
---------------------
### New Features

- PR [#23][], Issue [#17][], Issue [#19][], Issue [#21][], Issue [#23][]: Support for all Vagrant providers that hook into `Vagrant::Action::Builtin::Provision` for provisioning. ([@smdahlen][], [@michfield][], [@rjocoleman][])
- Issue [#15][]: Multi-VM Vagrantfiles are now fully supported. A global `omnibus.chef_version` will install the same version of Chef on all VMs OR declare a separate Chef version in the config block for each individual VM! ([@smdahlen][], [@schisamo][])
- PR [#10][]: Optionally change the location of `install.sh` via the `OMNIBUS_INSTALL_URL` environment variable. Default is still https://www.opscode.com/chef/install.sh. , ([@petecheslock][])

1.0.2 (April 20, 2013)
----------------------
### Improvements

- Unit test coverage for `VagrantPlugins::Omnibus::Config` ([@schisamo][])
- Add Rackspace provider acceptance test. ([@schisamo][])
- Parameterize the acceptance test Rake task, this allows you test run acceptance tests against a single provider. ([@schisamo][])

### Bug Fixes

- Issue [#2][]: Convert `Gem::Version` returned by `#retrieve_latest_chef_version` to a string. ([@schisamo][])
- Issue [#6][]: RubyGems 2.0 compat: use #empty? to check for results. ([@schisamo][])
- Issue [#7][]: Ensure 'vagrant-rackspace/action' is loaded. ([@schisamo][])
- Issue [#8][]: Trigger plugin if machine state is `:active`. ([@schisamo][])

1.0.1 (April 17, 2013)
----------------------
### Improvements

- Issue [#2][]: Resolve `latest` to a real Chef version. This ensures the plugin does not attempt to re-install Chef on subsequent provisions. ([@schisamo][])
- Issue [#4][]: Validate user provided value for omnibus.chef_version is in fact a real Chef version. ([@schisamo][])
- Retrieve omnibus.chef_version directly from global config. ([@schisamo][])
- Update development dependencies to vagrant (1.2.1) and vagrant-aws (0.2.1). ([@schisamo][])

### Bug Fixes

- Issue [#3][]: Plugin now correctly operates in "no-op" node if now `omnibus.chef_version` is not present in the Vagrantfile. ([@schisamo][])
- Use Ubuntu 12.04 release AMI for acceptance testing. ([@schisamo][])

1.0.0 (April 1, 2013)
---------------------

- The initial release.

<!--- The following link definition list is generated by PimpMyChangelog --->
[#2]: https://github.com/schisamo/vagrant-omnibus/issues/2
[#3]: https://github.com/schisamo/vagrant-omnibus/issues/3
[#4]: https://github.com/schisamo/vagrant-omnibus/issues/4
[#6]: https://github.com/schisamo/vagrant-omnibus/issues/6
[#7]: https://github.com/schisamo/vagrant-omnibus/issues/7
[#8]: https://github.com/schisamo/vagrant-omnibus/issues/8
[#10]: https://github.com/schisamo/vagrant-omnibus/issues/10
[#12]: https://github.com/schisamo/vagrant-omnibus/issues/12
[#13]: https://github.com/schisamo/vagrant-omnibus/issues/13
[#15]: https://github.com/schisamo/vagrant-omnibus/issues/15
[#17]: https://github.com/schisamo/vagrant-omnibus/issues/17
[#19]: https://github.com/schisamo/vagrant-omnibus/issues/19
[#21]: https://github.com/schisamo/vagrant-omnibus/issues/21
[#23]: https://github.com/schisamo/vagrant-omnibus/issues/23
[#27]: https://github.com/schisamo/vagrant-omnibus/issues/27
[#28]: https://github.com/schisamo/vagrant-omnibus/issues/28
[#31]: https://github.com/schisamo/vagrant-omnibus/issues/31
[#32]: https://github.com/schisamo/vagrant-omnibus/issues/32
[#33]: https://github.com/schisamo/vagrant-omnibus/issues/33
[#37]: https://github.com/schisamo/vagrant-omnibus/issues/37
[#38]: https://github.com/schisamo/vagrant-omnibus/issues/38
[#41]: https://github.com/schisamo/vagrant-omnibus/issues/41
[#43]: https://github.com/schisamo/vagrant-omnibus/issues/43
[#45]: https://github.com/schisamo/vagrant-omnibus/issues/45
[#48]: https://github.com/schisamo/vagrant-omnibus/issues/48
[#50]: https://github.com/schisamo/vagrant-omnibus/issues/50
[#52]: https://github.com/schisamo/vagrant-omnibus/issues/52
[#53]: https://github.com/schisamo/vagrant-omnibus/issues/53
[#56]: https://github.com/schisamo/vagrant-omnibus/issues/56
[#57]: https://github.com/schisamo/vagrant-omnibus/issues/57
[#59]: https://github.com/schisamo/vagrant-omnibus/issues/59
[#60]: https://github.com/schisamo/vagrant-omnibus/issues/60
[#61]: https://github.com/schisamo/vagrant-omnibus/issues/61
[#65]: https://github.com/schisamo/vagrant-omnibus/issues/65
[#66]: https://github.com/schisamo/vagrant-omnibus/issues/66
[#67]: https://github.com/schisamo/vagrant-omnibus/issues/67
[#69]: https://github.com/schisamo/vagrant-omnibus/issues/69
[#73]: https://github.com/schisamo/vagrant-omnibus/issues/73
[#79]: https://github.com/schisamo/vagrant-omnibus/issues/79
[@ampedandwired]: https://github.com/ampedandwired
[@comutt]: https://github.com/comutt
[@jarig]: https://github.com/jarig
[@matsu911]: https://github.com/matsu911
[@michfield]: https://github.com/michfield
[@petecheslock]: https://github.com/petecheslock
[@rjocoleman]: https://github.com/rjocoleman
[@scalp42]: https://github.com/scalp42
[@schisamo]: https://github.com/schisamo
[@skv-headless]: https://github.com/skv-headless
[@smdahlen]: https://github.com/smdahlen
[@srenatus]: https://github.com/srenatus
[@tknerr]: https://github.com/tknerr
[@tmatilai]: https://github.com/tmatilai
[@wizonesolutions]: https://github.com/wizonesolutions
