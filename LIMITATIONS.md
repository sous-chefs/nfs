# Limitations

## Package Availability

NFS client and server utilities are provided by operating system package repositories. This cookbook does not configure an upstream NFS vendor repository.

### APT (Debian/Ubuntu)

* Debian 12: `nfs-common` and `nfs-kernel-server` are available from the Debian archive for amd64, arm64, armel, armhf, i386, mips64el, mipsel, ppc64el, and s390x.
* Ubuntu 22.04 and 24.04: `nfs-common` and `nfs-kernel-server` are available from the Ubuntu archive for amd64, arm64, armhf, i386, ppc64el, riscv64, and s390x.

### DNF/YUM (RHEL family, Fedora, Amazon Linux)

* RHEL-compatible platforms use the distro `nfs-utils` and `rpcbind` packages.
* Fedora currently publishes `nfs-utils` for supported Fedora releases.
* Amazon Linux 2023 uses the distro `nfs-utils` and `rpcbind` packages.

### Zypper (SUSE)

* The helper defaults retain package and service mappings for SUSE family platforms, but this migration does not declare or test SUSE support in `metadata.rb`.

## Architecture Limitations

* Architecture support follows each operating system's package repositories.
* Server convergence requires a Linux kernel with NFS server support. Container-based Kitchen runs may need privileged Dokken with systemd.

## Source/Compiled Installation

This cookbook does not build NFS utilities from source.

## Known Issues

* Legacy recipe and node attribute APIs were removed in the full custom resource migration. Use the resources documented in `documentation/` and the breaking-change guide in `migration.md`.
* CentOS Linux and CentOS Stream 8 are end of life and are no longer tested.
