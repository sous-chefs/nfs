# frozen_string_literal: true

provides :nfs_idmap
unified_mode true

include Nfs::Cookbook::Helpers

use '_partial/_common'

property :config_path, String, default: '/etc/idmapd.conf'
property :domain, String, default: lazy { node['domain'] }
property :pipefs_directory, String, default: lazy { nfs_pipefs_directory }
property :user, String, default: 'nobody'
property :group, String, default: lazy { nfs_idmap_group }

default_action :create

action :create do
  template new_resource.config_path do
    source 'idmapd.conf.erb'
    cookbook 'nfs'
    mode '0644'
    variables(
      domain: new_resource.domain,
      pipefs_directory: new_resource.pipefs_directory,
      user: new_resource.user,
      group: new_resource.group
    )
    notifies :restart, "service[#{new_resource.idmap_service}]", :immediately
  end

  service new_resource.idmap_service do
    action [:enable, :start]
    supports status: true
  end
end

action :delete do
  service new_resource.idmap_service do
    action [:stop, :disable]
  end

  file new_resource.config_path do
    action :delete
  end
end
