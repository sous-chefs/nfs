#
# Cookbook:: nfs
# Resource:: export
#
# Copyright:: 2012, Riot Games
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

property :directory, String, name_property: true
property :network, [Array, Hash, String], required: true
property :writeable, [true, false], default: false
property :sync, [true, false], default: true
property :options, [Array, String], default: %w(root_squash)
property :anonuser, [Integer, String]
property :anongroup, [Integer, String]

action :create do
  with_run_context :root do
    declare_master_template

    if new_resource.network.is_a? Hash
      new_resource.network.each do |network, options|
        string_to_array(network).each do |host|
          node.run_state[:nfs_export_entries] << {
            dir: new_resource.directory,
            host: host,
            options: full_options(
              string_to_array(options) + string_to_array(new_resource.options)
            ),
          }
        end
      end
    else # Array or String
      string_to_array(new_resource.network).each do |host|
        node.run_state[:nfs_export_entries] << {
          dir: new_resource.directory,
          host: host,
          options: full_options(new_resource.options),
        }
      end
    end
  end

  # Update the resource to force template[/etc/exports] to react
  new_resource.updated_by_last_action(true)
end

action :remove do
  with_run_context :root do
    declare_master_template
    if new_resource.network.is_a? Hash
      new_resource.network.each_key do |hosts|
        string_to_array(hosts).each do |host|
          node.run_state[:nfs_export_unexport] << {
            dir: new_resource.directory,
            host: host.eql?('*') ? '.*' : host,
          }
        end
      end
    else
      string_to_array(new_resource.network).each do |host|
        node.run_state[:nfs_export_unexport] << {
          dir: new_resource.directory,
          host: host.eql?('*') ? '.*' : host,
        }
      end
    end
  end

  # Update the resource to force template[/etc/exports] to react
  new_resource.updated_by_last_action(true)
end

action_class do
  # Get all entries that would be written (exports - unexports -> sort)
  def actual_entries
    sorted = without_unexports.sort do |a, b|
      next a[:dir] <=> b[:dir] unless a[:dir].eql?(b[:dir])
      # the pipe character has a lower precedence then *
      host_a = a[:host].upcase.tr('*', '|')
      host_b = b[:host].upcase.tr('*', '|')
      host_a <=> host_b
    end
    sorted.map { |e| to_entry(e) }.uniq
  end

  def declare_master_template
    find_resource(:execute, 'exportfs') do
      command 'exportfs -ar'
      action :nothing
    end

    find_resource(:template, '/etc/exports') do
      source 'exports.erb'
      variables(lazy { { lines: actual_entries } })
      owner 'root'
      mode '0644'
      action :nothing
      notifies :run, 'execute[exportfs]'
    end

    # Subscribe the template to every export, because notifying from
    # the export is not possible (context is not instantiated?)
    edit_resource(:template, '/etc/exports') do
      cookbook 'nfs'
      subscribes :create, "nfs_export[#{new_resource.directory}]", :delayed
    end

    # Initialize the entries in /etc/exports
    node.run_state[:nfs_export_entries] ||= []
    node.run_state[:nfs_export_unexport] ||= []
  end

  def full_options(options)
    options = string_to_array(options)
    unless options.include?('ro') || options.include?('rw')
      options << (new_resource.writeable ? 'rw' : 'ro')
    end
    unless options.include?('async') || options.include?('sync')
      options << (new_resource.sync ? 'sync' : 'async')
    end
    if options.index { |o| o.start_with? 'anonuid=' }.nil? &&
       !new_resource.anonuser.nil?
      uid = new_resource.anonuser
      uid = Etc.getpwnam(uid).uid if uid.is_a? String
      options << "anonuid=#{uid}"
    end
    if options.index { |o| o.start_with? 'anongid=' }.nil? &&
       !new_resource.anongroup.nil?
      gid = new_resource.anonuser
      gid = Etc.getpwnam(gid).gid if gid.is_a? String
      options << "anongid=#{gid}"
    end
    options.uniq.sort
  end

  # Coerce strings to arrays by splitting them
  def string_to_array(string)
    string = string.split(/\s*,\s*/) if string.is_a?(String)
    string.sort
  end

  # Create an entry for /etc/exports
  def to_entry(export)
    options = export[:options]
    options = options.is_a?(Array) ? options.join(',') : options.gsub(/\s+/, '')
    "\"#{export[:dir]}\" #{export[:host]}(#{options})"
  end

  # Get all entries reduced by all unexports
  def without_unexports
    node.run_state[:nfs_export_entries].reject do |export|
      node.run_state[:nfs_export_unexport].any? do |unexport|
        export[:dir].match(unexport[:dir]) && export[:host].match(unexport[:host])
      end
    end
  end
end
