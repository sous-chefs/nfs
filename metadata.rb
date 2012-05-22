maintainer       "Eric G. Wolfe"
maintainer_email "wolfe21@marshall.edu"
license          "Apache 2.0"
description      "Installs and configures nfs, and NFS exports"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.2.2"

%w{ ubuntu debian redhat centos fedora scientific amazon oracle }.each do |os|
  supports os
end
