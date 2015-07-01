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

include_attribute 'sysctl'

# Allowing Version 2, 3 and 4 of NFS to be enabled or disabled.
# Default behavior, defer to protocol level(s) supported by kernel.
default['nfs']['v2'] = nil
default['nfs']['v3'] = nil
default['nfs']['v4'] = nil

# rquotad needed?
default['nfs']['rquotad'] = 'no'

# Default options are taken from the Debian guide on static NFS ports
default['nfs']['port']['statd'] = 32_765
default['nfs']['port']['statd_out'] = 32_766
default['nfs']['port']['mountd'] = 32_767
default['nfs']['port']['lockd'] = 32_768
default['nfs']['port']['rquotad'] = 32_769

# Number of rpc.nfsd threads to start (default 8)
default['nfs']['threads'] = 8

# Default options are based on RHEL6
default['nfs']['packages'] = %w(nfs-utils rpcbind)
default['nfs']['client_services'] = %w(portmap lock)
default['nfs']['client_nfs4_services'] =  []
default['nfs']['client_not_restartable_services'] = []
default['nfs']['service']['portmap'] = 'rpcbind'
default['nfs']['service']['lock'] = 'nfslock'
default['nfs']['service']['server'] = 'nfs'
default['nfs']['config']['client_templates'] = %w(/etc/sysconfig/nfs)
default['nfs']['config']['server_template'] = '/etc/sysconfig/nfs'

# idmap recipe attributes
default['nfs']['config']['idmap_template'] = '/etc/idmapd.conf'
default['nfs']['service']['idmap'] = 'rpcidmapd'
default['nfs']['idmap']['domain'] = node['domain']
default['nfs']['idmap']['pipefs_directory'] = '/var/lib/nfs/rpc_pipefs'
default['nfs']['idmap']['user'] = 'nobody'
default['nfs']['idmap']['group'] = 'nobody'

case node['platform_family']

when 'rhel'
  # RHEL5 edge case package set and portmap name
  if node['platform_version'].to_i <= 5
    default['nfs']['packages'] = %w(nfs-utils portmap)
    default['nfs']['service']['portmap'] = 'portmap'
  elsif node['platform_version'].to_i >= 7
    default['nfs']['service']['lock'] = 'nfs-lock'
    default['nfs']['service']['server'] = 'nfs-server'
    default['nfs']['service']['idmap'] = 'nfs-idmap'

    # Issue #63, Amazon Linux edge cases
    if node['platform'] == 'amazon' &&
       node['platform_version'] >= '2014.09' &&
       node['platform_version'] <= '2015.03'
      default['nfs']['service']['lock'] = 'nfslock'
      default['nfs']['service']['server'] = 'nfs'
      default['nfs']['service']['idmap'] = 'rpcidmapd'
    end

    if node['platform_version'] == '7.0.1406'
      default['nfs']['client_services'] = %w(nfs-lock.service)
    else
      default['nfs']['client_services'] = %w(nfs-client.target)
    end
  end

when 'freebsd'
  # Packages are installed by default
  default['nfs']['packages'] = []
  default['nfs']['config']['server_template'] = '/etc/rc.conf.d/nfsd'
  default['nfs']['config']['client_templates'] = %w(/etc/rc.conf.d/mountd)
  default['nfs']['service']['lock'] = 'lockd'
  default['nfs']['service']['server'] = 'nfsd'
  default['nfs']['threads'] = 24
  default['nfs']['mountd_flags'] = '-r'
  if node['nfs']['threads'] >= 0
    default['nfs']['server_flags'] = "-u -t -n #{node['nfs']['threads']}"
  else
    default['nfs']['server_flags'] = '-u -t'
  end

when 'suse'
  default['nfs']['packages'] = %w(nfs-client nfs-kernel-server rpcbind)
  default['nfs']['service']['lock'] = 'nfsserver'
  default['nfs']['service']['server'] = 'nfsserver'
  default['nfs']['config']['client_templates'] = %w(/etc/sysconfig/nfs)

when 'debian'
  # Use Debian 7 as default case
  default['nfs']['packages'] = %w(nfs-common rpcbind)
  default['nfs']['service']['portmap'] = 'rpcbind'
  default['nfs']['service']['lock'] = 'nfs-common'
  default['nfs']['service']['idmap'] = 'nfs-common'
  default['nfs']['service']['server'] = 'nfs-kernel-server'
  default['nfs']['config']['client_templates'] = %w(/etc/default/nfs-common /etc/modprobe.d/lockd.conf)
  default['nfs']['config']['server_template'] = '/etc/default/nfs-kernel-server'
  default['nfs']['idmap']['group'] = 'nogroup'

  # Debian 6.0
  if node['platform_version'].to_i <= 6
    default['nfs']['packages'] = %w(nfs-common portmap)
    default['nfs']['service']['portmap'] = 'portmap'
  end

  case node['platform']

  when 'ubuntu'
    default['nfs']['service']['portmap'] = 'rpcbind-boot'
    default['nfs']['service']['lock'] = 'statd' # There is no lock service on Ubuntu
    default['nfs']['service']['idmap'] = 'idmapd'
    default['nfs']['idmap']['pipefs_directory'] = '/run/rpc_pipefs'
    default['nfs']['service_provider']['idmap'] = Chef::Provider::Service::Upstart
    default['nfs']['service_provider']['portmap'] = Chef::Provider::Service::Upstart
    default['nfs']['service_provider']['lock'] = Chef::Provider::Service::Upstart

    # Ubuntu 11.04 and 14.04 service script edge cases
    if node['platform_version'].to_f <= 11.04 ||
       node['platform_version'].to_f >= 14.04
      default['nfs']['service']['portmap'] = 'rpcbind'
    end
  end

when 'solaris2'
  if node['platform_version'].to_f == 5.10
    default['nfs']['packages'] = []
    default['nfs']['client_services'] = %w(portmap client lock quota statd)
    default['nfs']['client_restartable_services'] = %w(client lock quota statd)
    default['nfs']['client_nfs4_services'] = %w(cbd)
    default['nfs']['service']['cbd'] = '/network/nfs/cbd'
    default['nfs']['service']['client'] = '/network/nfs/client'
    default['nfs']['service']['idmap'] = '/network/nfs/mapid'
    default['nfs']['service']['lock'] = '/network/nfs/nlockmgr'
    default['nfs']['service']['portmap'] = '/network/rpc/bind'
    default['nfs']['service']['quota'] = '/network/nfs/rquota'
    default['nfs']['service']['server'] = '/network/nfs/server'
    default['nfs']['service']['statd'] = '/network/nfs/status'
    default['nfs']['config']['client_templates'] = %w(/etc/default/nfs)
    default['nfs']['config']['server_template'] = '/etc/sysconfig/nfs'
    default['nfs']['opt'] = {}
  end

end
