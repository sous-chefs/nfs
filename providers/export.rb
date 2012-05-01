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

def load_current_resource
  @export = Chef::Resource::NfsExport.new(new_resource.directory)
  Chef::Log.debug("Checking whether #{new_resource.directory} is already an NFS export")
  @export.exists node['nfs']['exports'].detect {|x| x.match "^#{new_resource.directory}" }
end

action :create do
  unless @export.exists
    ro_rw = new_resource.writeable ? "rw" : "ro"
    sync_async = new_resource.sync ? "sync" : "async"
    options = new_resource.options.join(',')
    options = ",#{options}" unless options.empty?
    export = "#{new_resource.directory} #{new_resource.network}(#{ro_rw},#{sync_async}#{options})"
    node['nfs']['exports'] << export
    execute "notify_export_create" do
      command "/bin/true"
      notifies :create, resources("template[/etc/exports]")
      action :run
    end
    new_resource.updated_by_last_action(true)
  end
end
