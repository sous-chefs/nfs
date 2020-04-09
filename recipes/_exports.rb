#
# Cookbook:: nfs
# Recipe:: _export
#
# Copyright:: 2020, Andre Kerkhoff
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

(node['nfs']['exports'] || {}).each do |dir, attrs|
  nfs_export dir do
    if attrs.nil?
      network '*'
    elsif attrs.is_a?(Array) || attrs.is_a?(String)
      network attrs
    elsif attrs.is_a? Hash
      networks = attrs.reject do |key, _|
        %w(network options writeable sync anonuser anongroup).any? do |k|
          k.eql? key
        end
      end

      if networks.empty?
        network attrs['network'] || '*'
      else
        network networks
      end

      options attrs['options'] unless attrs['options'].nil?
      writeable attrs['writeable'] unless attrs['writeable'].nil?
      sync attrs['sync'] unless attrs['sync'].nil?
      anonuser attrs['anonuser'] unless attrs['anonuser'].nil?
      anongroup attrs['anongroup'] unless attrs['anongroup'].nil?
    else
      raise "Values under node['nfs']['exports'][X] must be Arrays, Hashes " \
            'or Strings'
    end
    action :create
  end
end

(node['nfs']['unexports'] || {}).each do |dir, network|
  nfs_export dir do
    network network
    action :remove
  end
end
