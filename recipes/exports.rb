#
# Cookbook Name:: nfs
# Recipe:: exports
#
# Copyright 2013, Unbekandt Léo
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

# Add export using LWRP from the cookbook
node['nfs']['exports'].each do |e|
  nfs_export e.directory do
    network e.network
    writeable e.writeable
    sync e.sync
    options e.options
  end
end

