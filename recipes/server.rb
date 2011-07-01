#
# Cookbook Name:: nfs
# Recipe:: server 
#
# Copyright 2011, Eric G. Wolfe
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

include_recipe "nfs"

# Install server components for Debian
case node["platform"]
  when "debian","ubuntu"
    package "nfs-kernel-server"
end

# Start nfs-server components
service "nfs-server" do
  case node["platform"]
    when "redhat","centos","scientific"
      service_name "nfs"
    when "ubuntu","debian"
      service_name "nfs-kernel-server"
  end
  action [ :start, :enable ]
end

# Configure nfs-server components
case node["platform"]
  when "redhat","centos","scientific"
    template "/etc/sysconfig/nfs" do
      mode 0644
      notifies :restart, "service[nfs-server]"
    end
  when "ubuntu","debian"
    template "/etc/default/nfs-kernel-server" do
      mode 0644
      notifies :restart, "service[nfs-server]"
    end
end
