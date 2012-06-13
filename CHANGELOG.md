## v0.2.4
Attribute typo for Debian

* Correct typo in attributes
* Add attribute testing for config templates
* Add /etc/exports grep for better idempotency guard

## v0.2.3

* Fix service action typo in nfs::undo

## v0.2.2

* [annoyance] Add run once nfs::undo recipe to stop and remove all nfs components
* Correct export duplication check in LWRP
* Re-factor attributes, and introduce Ubuntu 12+ edge cases
* Add testing artefacts for Travis CI integration

## v0.2.0

* Add nfs_export LWRP, thanks Michael Ivey from Riot Games for the contribution
* Update README documentation, and add CHANGELOG

## v0.1.0

* Re-factor NFS cookbook
* Add edge cases for RHEL6, thanks Bryan Berry for reporting and testing
* Filter-branched into cookbook-nfs repo

## v0.0.6

* Add NFS export support
* Update documentation
* First community site release

## v0.0.4

* Initial version with RHEL/CentOS/Debian/Ubuntu support
* Thanks to Glenn Pratt for testing on Debian family distros
