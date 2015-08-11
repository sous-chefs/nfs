#
# Cookbook Name:: nfs
# Recipe:: server
#
# Copyright 2011-2014, Eric G. Wolfe
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'nfs::_common'

# Install server components for Debian
package 'nfs-kernel-server' if node['platform_family'] == 'debian'

# Configure nfs-server components
template node['nfs']['config']['server_template'] do
  source 'nfs.erb'
  mode 00644
  notifies :restart, "service[#{node['nfs']['service']['server']}]"
end

# RHEL7 has some extra requriements per
# https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Storage_Administration_Guide/nfs-serverconfig.html#s2-nfs-nfs-firewall-config
if node['platform_family'] == 'rhel' && node['platform_version'].to_f >= 7.0 && !node['platform'] == 'amazon'
  include_recipe 'sysctl::default'

  sysctl_param 'fs.nfs.nlm_tcpport' do
    value node['nfs']['port']['lockd']
  end

  sysctl_param 'fs.nfs.nlm_udpport' do
    value node['nfs']['port']['lockd']
  end
end

# Start nfs-server components
service node['nfs']['service']['server'] do
  action [:start, :enable]
  supports status: true
end
