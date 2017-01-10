#
# Cookbook Name:: nfs
# Recipe:: _idmap
#
# Copyright 2014, Eric G. Wolfe
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

# Issue #93: nfs-idmapd service appears to depend on nfs-server service for
# Ubuntu 16.04. Perhaps a systemd unit file bug, or nfs-idmap unneeded for nfs4
# client services on Ubuntu?
package 'nfs-kernel-server' do
  action :install
  only_if do
    node['platform'] == 'ubuntu' &&
      node['platform_version'].to_f >= 15.04
  end
end

# Configure idmap template for NFSv4 client/server support
template node['nfs']['config']['idmap_template'] do
  mode 0o0644
  notifies :restart, 'service[idmap]', :immediately
end

# Start idmapd components
service 'idmap' do
  service_name node['nfs']['service']['idmap']
  action [:start, :enable]
  supports status: true
end
