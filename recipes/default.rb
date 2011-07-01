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

# Install package, dependent on platform
node["nfs"]["packages"].each do |nfspkg|
  package nfspkg
end

# Start portmap on 111
service "portmap" do
  action [ :start, :enable ]
end

# Start NFS client components
service "nfs-client" do
  case node["platform"]
    when "redhat","centos","scientific"
      service_name "nfslock"
    when "debian","ubuntu"
      service_name "statd"
  end
  action [ :enable, :start ]
end

# Configure NFS client components
case node["platform"]
  when "redhat","centos","scientific"
    template "/etc/sysconfig/nfs" do
      mode 0644
      notifies :restart, "service[nfs-client]"
    end
  when "debian","ubuntu"
    template "/etc/modprobe.d/lockd.conf" do
      mode 0644
    end
    template "/etc/default/nfs-common" do
      mode 0644
      notifies :restart, "service[nfs-client]"
    end
end
