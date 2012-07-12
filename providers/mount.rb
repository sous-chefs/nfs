#
# Cookbook Name:: nfs
# Providers:: export
#
# Copyright 2012, Riot Games
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

action :create do
  mount_ip = @new_resource.mount_ip
  mount_path = @new_resource.mount_path
  dir = @new_resource.directory
  owner = @new_resource.owner
  group = @new_resource.group

  execute "remove old mount" do
    command "umount -lf #{dir}"
    only_if "test `mount | grep '#{dir}' | wc -l` = 1"
  end

  directory dir do
    recursive true
    owner owner
    group group
    action :create
  end

  script "mount_nfs" do
    interpreter "bash"
    user "root"
    code <<-EOH

    grep -v "#{dir}" /etc/fstab > /tmp/fstab
    echo "#{mount_ip}:#{mount_path} #{dir} nfs rw 0 2" >> /tmp/fstab
    mv /tmp/fstab /etc/fstab

    mount #{dir}

    EOH
  end

end
