#
# Cookbook:: nfs
# Recipe:: _sysctl
#
# Copyright:: 2011-2018, Eric G. Wolfe
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

# Related to https://bugzilla.redhat.com/show_bug.cgi?id=1413272
# Seems like this is also a bug on Debian 8, and Ubuntu 14.04
return unless (platform_family?('rhel') && node['platform_version'].to_f >= 7.0 &&
              !platform?('amazon') && node['virtualization']['system'] != 'openvz') ||
              (platform_family?('debian') && node['platform_version'].to_i == 8)

sysctl_keys = %w(fs.nfs.nlm_tcpport fs.nfs.nlm_udpport)
sysctl_keys.each do |key|
  sysctl key do
    value node['nfs']['port']['lockd']
    only_if { node['kernel']['modules'].include?('lockd') }
  end
end

service 'rpcbind' do
  action [:start, :enable]
  supports status: true
end
