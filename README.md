DESCRIPTION
===========

Installs and configures NFS client, or server components 

REQUIREMENTS
============

Should work on any Red Hat-family or Debian-family Linux distribution.

ATTRIBUTES
==========

* nfs['packages']

  - Makes a best effort to choose NFS client packages dependent on platform
  - NFS server package needs to be hardcoded for Debian/Ubuntu in the server
    recipe, or overridden in a role.

* nfs['service']
  - portmap - the portmap or rpcbind service depending on platform
  - lock - the statd or nfslock service depending on platform
  - server - the server component, nfs or nfs-kernel-server depending on platform

* nfs['config']
  - client\_templates - templates to iterate through on client systems, chosen by platform
  - server\_template - server specific template, chosen by platform

* nfs['port']

  - ['statd'] = Listen port for statd, default 32765
  - ['statd\_out'] = Outgoing port for statd, default 32766
  - ['mountd'] = Listen port for mountd, default 32767
  - ['lockd'] = Listen port for lockd, default 32768

* nfs['exports']

  - An array of strings to populate in an export file. Can be manipulated in
    recipes with the nfs_export LWRP.

USAGE
=====

To install the NFS components for a client system, simply add nfs to the run_list.

    name "base"
    description "Role applied to all systems"
    run_list => [ "nfs" ]

Then in an nfs\_server.rb role that is applied to NFS servers:

    name "nfs_server"
    description "Role applied to the system that should be an NFS server."
    override_attributes(
      "nfs" => {
        "packages" => [ "portmap", "nfs-common", "nfs-kernel-server" ],
        "ports" => {
          "statd" => 32765,
          "statd_out" => 32766,
          "mountd" => 32767,
          "lockd" => 32768
        },
        "exports" => [
          "/exports 10.0.0.0/8(ro,sync,no_root_squash)"
        ]
      }
    )
    run_list => [ "nfs::server" ]

Applications or other cookbooks can setup exports with nfs_export:

    nfs_export "/foobar" do
      network '*'
      writeable true
      sync false
      extra_options ['no_root_squash']
    end

LICENSE AND AUTHOR
==================

Author:: Eric G. Wolfe (<wolfe21@marshall.edu>)

Copyright 2011

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
