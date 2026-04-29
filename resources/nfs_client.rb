# frozen_string_literal: true

provides :nfs_client
unified_mode true

include Nfs::Cookbook::Helpers

use '_partial/_common'

default_action :create

action :create do
  service_names = [
    new_resource.portmap_service,
    new_resource.statd_service,
    new_resource.lock_service,
  ].uniq

  new_resource.packages.each do |package_name|
    package package_name
  end

  service new_resource.rpcbind_service do
    action [:enable, :start]
    supports status: true
  end

  new_resource.client_config_paths.each do |config_path|
    template config_path do
      source nfs_template_source(config_path)
      cookbook 'nfs'
      mode '0644'
      variables nfs_template_variables(new_resource)
      service_names.each do |service_name|
        notifies :restart, "service[#{service_name}]", :delayed
      end
    end
  end

  kernel_module 'lockd' do
    options [
      "nlm_udpport=#{new_resource.lockd_port}",
      "nlm_tcpport=#{new_resource.lockd_port}",
    ]
    service_names.each do |service_name|
      notifies :restart, "service[#{service_name}]", :delayed
    end
    not_if { docker? || !new_resource.manage_lockd }
  end

  service_names.each do |service_name|
    service service_name do
      action [:enable, :start]
      supports status: true
    end
  end
end

action :delete do
  [
    new_resource.rpcbind_service,
    new_resource.portmap_service,
    new_resource.statd_service,
    new_resource.lock_service,
  ].uniq.each do |service_name|
    service service_name do
      action [:stop, :disable]
    end
  end

  kernel_module 'lockd' do
    action :uninstall
    not_if { docker? || !new_resource.manage_lockd }
  end

  new_resource.client_config_paths.each do |config_path|
    file config_path do
      action :delete
    end
  end

  new_resource.packages.each do |package_name|
    package package_name do
      action :remove
    end
  end
end

action_class do
  include Nfs::Cookbook::Helpers

  def nfs_template_variables(resource)
    {
      pipefs_directory: nfs_pipefs_directory,
      statd_port: resource.statd_port,
      statd_out_port: resource.statd_out_port,
      mountd_port: resource.mountd_port,
      lockd_port: resource.lockd_port,
      rquotad_port: resource.rquotad_port,
      threads: resource.threads,
      nfs_v2: resource.nfs_v2,
      nfs_v3: resource.nfs_v3,
      nfs_v4: resource.nfs_v4,
      rquotad: resource.rquotad,
    }
  end
end
