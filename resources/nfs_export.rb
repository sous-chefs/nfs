# frozen_string_literal: true

provides :nfs_export
unified_mode true

property :directory, String, name_property: true
property :network, [String, Array], required: true
property :writeable, [true, false], default: false
property :sync, [true, false], default: true
property :options, Array, default: ['root_squash']
property :anonuser, String
property :anongroup, String
property :unique, [true, false], default: false
property :fsid, String, default: 'root'
property :exports_file, String, default: '/etc/exports'

default_action :create

action :create do
  export_line = nfs_export_line(
    directory: new_resource.directory,
    network: new_resource.network,
    writeable: new_resource.writeable,
    sync: new_resource.sync,
    options: new_resource.options,
    anonuser: new_resource.anonuser,
    anongroup: new_resource.anongroup,
    fsid: new_resource.fsid
  )

  file new_resource.exports_file do
    content ''
    action :create_if_missing
  end

  execute 'exportfs' do
    command 'exportfs -ar'
    default_env true
    action :nothing
    not_if { docker? }
  end

  if new_resource.unique
    replace_or_add "export #{new_resource.name}" do
      path new_resource.exports_file
      pattern "^#{Regexp.escape(new_resource.directory)}\\s"
      line export_line
      notifies :run, 'execute[exportfs]', :immediately
    end
  else
    append_if_no_line "export #{new_resource.name}" do
      path new_resource.exports_file
      line export_line
      notifies :run, 'execute[exportfs]', :immediately
    end
  end
end

action :delete do
  execute 'exportfs' do
    command 'exportfs -ar'
    default_env true
    action :nothing
    not_if { docker? }
  end

  delete_lines "export #{new_resource.name}" do
    path new_resource.exports_file
    pattern "^#{Regexp.escape(new_resource.directory)}\\s"
    notifies :run, 'execute[exportfs]', :immediately
  end
end

action_class do
  include Nfs::Cookbook::Helpers
end
