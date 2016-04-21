maintainer 'Eric G. Wolfe'
maintainer_email 'eric.wolfe@gmail.com'
license 'Apache 2.0'
description 'Installs and configures NFS, and NFS exports'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
name 'nfs'
version '2.2.7'
source_url 'https://github.com/atomic-penguin/cookbook-nfs'
issues_url 'https://github.com/atomic-penguin/cookbook-nfs/issues'

%w(ubuntu debian redhat centos fedora scientific amazon oracle sles freebsd).each do |os|
  supports os
end

depends 'line'
depends 'sysctl'
