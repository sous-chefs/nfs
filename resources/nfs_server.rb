# frozen_string_literal: true

provides :nfs_server
unified_mode true

include Nfs::Cookbook::Helpers

use '_partial/_common'

property :server_packages, Array, default: lazy { nfs_server_packages }
property :manage_idmap, [true, false], default: false

default_action :create

action :create do
  service_names = [
    new_resource.portmap_service,
    new_resource.statd_service,
    new_resource.lock_service,
    new_resource.server_service,
  ].uniq

  (new_resource.packages + new_resource.server_packages).uniq.each do |package_name|
    package package_name
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

  unless new_resource.client_config_paths.include?(new_resource.server_config_path)
    template new_resource.server_config_path do
      source nfs_template_source(new_resource.server_config_path)
      cookbook 'nfs'
      mode '0644'
      variables nfs_template_variables(new_resource)
      notifies :restart, "service[#{new_resource.server_service}]", :delayed
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

  %w(fs.nfs.nlm_tcpport fs.nfs.nlm_udpport).each do |key|
    sysctl key do
      value new_resource.lockd_port
      not_if { docker? }
    end
  end

  service new_resource.rpcbind_service do
    action [:enable, :start]
    supports status: true
  end

  nfs_idmap "server #{new_resource.name}" do
    idmap_service new_resource.idmap_service
    action :create
    only_if { new_resource.manage_idmap }
  end

  service new_resource.server_service do
    action [:enable, :start]
    supports status: true
  end

  service_names.each do |service_name|
    next if service_name == new_resource.server_service

    service service_name do
      action [:enable, :start]
      supports status: true
    end
  end
end

action :delete do
  [
    new_resource.server_service,
    new_resource.portmap_service,
    new_resource.statd_service,
    new_resource.lock_service,
  ].uniq.each do |service_name|
    service service_name do
      action [:stop, :disable]
    end
  end

  service new_resource.rpcbind_service do
    action [:stop, :disable]
  end

  nfs_idmap "server #{new_resource.name}" do
    config_path '/etc/idmapd.conf'
    idmap_service new_resource.idmap_service
    action :delete
    only_if { new_resource.manage_idmap }
  end

  kernel_module 'lockd' do
    action :uninstall
    not_if { docker? || !new_resource.manage_lockd }
  end

  %w(fs.nfs.nlm_tcpport fs.nfs.nlm_udpport).each do |key|
    sysctl key do
      action :remove
      not_if { docker? }
    end
  end

  (new_resource.client_config_paths + [new_resource.server_config_path]).uniq.each do |config_path|
    file config_path do
      action :delete
    end
  end

  (new_resource.server_packages + new_resource.packages).uniq.each do |package_name|
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
