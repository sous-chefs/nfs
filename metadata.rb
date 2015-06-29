maintainer 'Eric G. Wolfe'
maintainer_email 'eric.wolfe@gmail.com'
license 'Apache 2.0'
description 'Installs and configures nfs, and NFS exports'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
name 'nfs'
version '2.2.1'
recipe 'nfs', 'Installs and configures nfs client components'
recipe 'nfs::server', 'Installs and configures nfs server components'
recipe 'nfs::client4', 'NFSv4 client components'
recipe 'nfs::server4', 'NFSv4 server components'
recipe 'nfs::undo', 'Undo both default and server recipes'

%w(ubuntu debian redhat centos fedora scientific amazon oracle sles freebsd).each do |os|
  supports os
end

depends 'line'
