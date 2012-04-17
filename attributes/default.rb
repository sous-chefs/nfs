#
# Cookbook Name:: nfs
# Attributes:: default
#
# Copyright 2011, Eric G. Wolfe
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['platform']
when 'redhat','centos','scientific','amazon'
  if node['platform_version'].to_i >= 6
    # RHEL/CentOS 6 portmap/rpcbind edge case, thanks BryanWB!
    default['nfs']['packages'] = [ 'nfs-utils', 'rpcbind' ]
    default['nfs']['service']['portmap'] = 'rpcbind'
  else
    # RHEL/CentOS <= 5 portmap/packages
    default['nfs']['packages'] = [ 'nfs-utils', 'portmap' ]
    default['nfs']['service']['portmap'] = 'portmap'
  end
  # General RHEL/Centos options
  default['nfs']['service']['lock'] = 'nfslock'
  default['nfs']['service']['server'] = 'nfs'
  default['nfs']['config']['client_templates'] = [ '/etc/sysconfig/nfs' ]
  default['nfs']['config']['server_template'] = '/etc/sysconfig/nfs'

when 'ubuntu','debian'
  # Same service edge case on Ubuntu greater than 11 for portmap/rpcbind
  if node['platform_version'].to_i >= 11
    default['nfs']['service']['portmap'] = 'rpcbind'
  else
    default['nfs']['service']['portmap'] = 'portmap'
  end
  # General Ubuntu, Debian options, may not work on all versions
  default['nfs']['packages'] = [ 'nfs-common', 'portmap' ]
  default['nfs']['service']['lock'] = 'statd'
  default['nfs']['service']['server'] = 'nfs-kernel-server'
  default['nfs']['config']['client_templates'] = [ '/etc/default/nfs-common', '/etc/modprobe.d/lockd.conf' ]
  default['nfs']['config']['server_template'] = '/etc/default/nfs-kernel-server'

else
  # Else on your own to set something as an override 
  default['nfs']['packages'] = Array.new
  default['nfs']['service']['portmap'] = Nil
  default['nfs']['service']['lock'] = Nil
  default['nfs']['service']['server'] = Nil
  default['nfs']['config']['client_templates'] = Nil
  default['nfs']['config']['server_template'] = Nil
end

# Default options are taken from the Debian guide on static NFS ports
default['nfs']['port']['statd'] = 32765
default['nfs']['port']['statd_out'] = 32766
default['nfs']['port']['mountd'] = 32767
default['nfs']['port']['lockd'] = 32768
default['nfs']['exports'] = Array.new
