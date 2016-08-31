# Change Log

## [1.5.0](https://github.com/chef/vagrant-omnibus/tree/1.5.0) (2016-08-31)
[Full Changelog](https://github.com/chef/vagrant-omnibus/compare/v1.4.1...1.5.0)

**Merged pull requests:**

- Convert specs to rspec 3 format [\#138](https://github.com/chef/vagrant-omnibus/pull/138) ([tas50](https://github.com/tas50))
- Testing improvements, dep bumps, and fixes [\#137](https://github.com/chef/vagrant-omnibus/pull/137) ([tas50](https://github.com/tas50))
- Fix installing chef on windows in vagrant 1.8.3 and up [\#135](https://github.com/chef/vagrant-omnibus/pull/135) ([mwrock](https://github.com/mwrock))
- Fixed Travis CI image and link. [\#115](https://github.com/chef/vagrant-omnibus/pull/115) ([mbrukman](https://github.com/mbrukman))
- Update README.md to point to current Travis location [\#101](https://github.com/chef/vagrant-omnibus/pull/101) ([petems](https://github.com/petems))
- Change :latest to not hit rubygems [\#97](https://github.com/chef/vagrant-omnibus/pull/97) ([lamont-granquist](https://github.com/lamont-granquist))
- README: added info about Windows support [\#94](https://github.com/chef/vagrant-omnibus/pull/94) ([docwhat](https://github.com/docwhat))
- Fix string to use Ruby variables in tests [\#93](https://github.com/chef/vagrant-omnibus/pull/93) ([petems](https://github.com/petems))
- Add plugin spec [\#92](https://github.com/chef/vagrant-omnibus/pull/92) ([petems](https://github.com/petems))

## [v1.4.1](https://github.com/chef/vagrant-omnibus/tree/v1.4.1) (2014-04-26)
[Full Changelog](https://github.com/chef/vagrant-omnibus/compare/v1.4.0...v1.4.1)

## [v1.4.0](https://github.com/chef/vagrant-omnibus/tree/v1.4.0) (2014-04-25)
[Full Changelog](https://github.com/chef/vagrant-omnibus/compare/v1.3.1...v1.4.0)

**Merged pull requests:**

- Cache omnibus download, expose config options [\#73](https://github.com/chef/vagrant-omnibus/pull/73) ([tknerr](https://github.com/tknerr))
- Fix not specified chef version without internet connection [\#67](https://github.com/chef/vagrant-omnibus/pull/67) ([skv-headless](https://github.com/skv-headless))

## [v1.3.1](https://github.com/chef/vagrant-omnibus/tree/v1.3.1) (2014-03-12)
[Full Changelog](https://github.com/chef/vagrant-omnibus/compare/v1.3.0...v1.3.1)

**Merged pull requests:**

- run install.sh with `sh` rather than `bash`... [\#66](https://github.com/chef/vagrant-omnibus/pull/66) ([tknerr](https://github.com/tknerr))
- make unlinking the install.sh reliably work on windows hosts [\#65](https://github.com/chef/vagrant-omnibus/pull/65) ([tknerr](https://github.com/tknerr))

## [v1.3.0](https://github.com/chef/vagrant-omnibus/tree/v1.3.0) (2014-02-24)
[Full Changelog](https://github.com/chef/vagrant-omnibus/compare/v1.2.1...v1.3.0)

**Merged pull requests:**

- Make detection of currently installed Chef version more robust [\#61](https://github.com/chef/vagrant-omnibus/pull/61) ([ampedandwired](https://github.com/ampedandwired))
- Windows Support Part Deux [\#60](https://github.com/chef/vagrant-omnibus/pull/60) ([schisamo](https://github.com/schisamo))

## [v1.2.1](https://github.com/chef/vagrant-omnibus/tree/v1.2.1) (2013-12-18)
[Full Changelog](https://github.com/chef/vagrant-omnibus/compare/v1.2.0...v1.2.1)

**Merged pull requests:**

- filder 'stdin is not a tty' when trying to figure installed Chef version [\#57](https://github.com/chef/vagrant-omnibus/pull/57) ([scalp42](https://github.com/scalp42))

## [v1.2.0](https://github.com/chef/vagrant-omnibus/tree/v1.2.0) (2013-12-17)
[Full Changelog](https://github.com/chef/vagrant-omnibus/compare/v1.1.2...v1.2.0)

**Merged pull requests:**

- Ruby linting with Rubocop [\#56](https://github.com/chef/vagrant-omnibus/pull/56) ([schisamo](https://github.com/schisamo))
- Fix installed version check to be more robust [\#53](https://github.com/chef/vagrant-omnibus/pull/53) ([comutt](https://github.com/comutt))
- Change plugin name to correspond gem name [\#52](https://github.com/chef/vagrant-omnibus/pull/52) ([tmatilai](https://github.com/tmatilai))
- Update README.md with vagrant-parallels compatibility [\#50](https://github.com/chef/vagrant-omnibus/pull/50) ([wizonesolutions](https://github.com/wizonesolutions))
- Don't install Chef if `--no-provision` is specified [\#48](https://github.com/chef/vagrant-omnibus/pull/48) ([tmatilai](https://github.com/tmatilai))

## [v1.1.2](https://github.com/chef/vagrant-omnibus/tree/v1.1.2) (2013-10-17)
[Full Changelog](https://github.com/chef/vagrant-omnibus/compare/v1.1.1...v1.1.2)

**Merged pull requests:**

- Compatibility with vagrant-aws v0.4.0 [\#45](https://github.com/chef/vagrant-omnibus/pull/45) ([tmatilai](https://github.com/tmatilai))
- Fix development dependencies and Travis tests [\#43](https://github.com/chef/vagrant-omnibus/pull/43) ([tmatilai](https://github.com/tmatilai))
- Add vagrant-digitalocean to the list of supported providers [\#41](https://github.com/chef/vagrant-omnibus/pull/41) ([tmatilai](https://github.com/tmatilai))

## [v1.1.1](https://github.com/chef/vagrant-omnibus/tree/v1.1.1) (2013-09-04)
[Full Changelog](https://github.com/chef/vagrant-omnibus/compare/v1.1.0...v1.1.1)

**Merged pull requests:**

- Document that newer than v1.1.x Vagrant is fine, too [\#37](https://github.com/chef/vagrant-omnibus/pull/37) ([tmatilai](https://github.com/tmatilai))
- Fix the curl line to install the requested Chef version [\#32](https://github.com/chef/vagrant-omnibus/pull/32) ([tmatilai](https://github.com/tmatilai))
- no need to do sudo in sudo [\#31](https://github.com/chef/vagrant-omnibus/pull/31) ([matsu911](https://github.com/matsu911))
- include OpenStack provider into the list of working providers [\#28](https://github.com/chef/vagrant-omnibus/pull/28) ([srenatus](https://github.com/srenatus))

## [v1.1.0](https://github.com/chef/vagrant-omnibus/tree/v1.1.0) (2013-06-21)
[Full Changelog](https://github.com/chef/vagrant-omnibus/compare/v1.0.2...v1.1.0)

**Merged pull requests:**

- add support for vmware\_fusion [\#17](https://github.com/chef/vagrant-omnibus/pull/17) ([rjocoleman](https://github.com/rjocoleman))

## [v1.0.2](https://github.com/chef/vagrant-omnibus/tree/v1.0.2) (2013-04-20)
[Full Changelog](https://github.com/chef/vagrant-omnibus/compare/v1.0.1...v1.0.2)

## [v1.0.1](https://github.com/chef/vagrant-omnibus/tree/v1.0.1) (2013-04-18)
[Full Changelog](https://github.com/chef/vagrant-omnibus/compare/v1.0.0...v1.0.1)

## [v1.0.0](https://github.com/chef/vagrant-omnibus/tree/v1.0.0) (2013-04-02)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*