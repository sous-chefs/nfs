#
# Cookbook Name:: nfs
# Recipe:: _sysctl
#
# Copyright 2011-2018, Eric G. Wolfe
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
return unless node['platform_family'] == 'rhel' && node['platform_version'].to_f >= 7.0 &&
              node['platform'] != 'amazon' && node['virtualization']['system'] != 'openvz'

sysctl_keys = %w(fs.nfs.nlm_tcpport fs.nfs.nlm_udpport)

if Chef::VERSION.to_f >= 14.0
  sysctl_keys.each do |key|
    sysctl key do
      value node['nfs']['port']['lockd']
      only_if { node['kernel']['modules'].include?('lockd') }
    end
  end
else
  sysctl_keys.each do |key|
    file "/etc/sysctl.d/99-chef-#{key}.conf" do
      content "#{key} = #{node['nfs']['port']['lockd']}"
      only_if { node['kernel']['modules'].include?('lockd') }
    end

    execute "sysctl -p /etc/sysctl.d/99-chef-#{key}.conf" do
      action :run
      #subscribes :run, "file[/etc/sysctl.d/chef-99-#{key}.conf]", :immediately
    end
  end
end

service 'rpcbind' do
  action [:start, :enable]
  supports status: true
end
