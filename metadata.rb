# frozen_string_literal: true

name              'nfs'
maintainer        'Sous Chefs'
maintainer_email  'help@sous-chefs.org'
license           'Apache-2.0'
description       'Provides custom resources for NFS client, server, idmap, and exports'
version           '5.1.7'
source_url        'https://github.com/sous-chefs/nfs'
issues_url        'https://github.com/sous-chefs/nfs/issues'
chef_version      '>= 15.3'

supports 'almalinux', '>= 8.0'
supports 'amazon', '>= 2023.0'
supports 'centos_stream', '>= 9.0'
supports 'debian', '>= 12.0'
supports 'fedora'
supports 'oracle', '>= 8.0'
supports 'redhat', '>= 8.0'
supports 'rocky', '>= 8.0'
supports 'ubuntu', '>= 22.04'

depends 'line'
