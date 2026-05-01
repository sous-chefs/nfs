property :packages, Array, default: lazy { nfs_packages }
property :client_config_paths, Array, default: lazy { nfs_client_config_paths }
property :server_config_path, String, default: lazy { nfs_server_config_path }
property :client_services, Array, default: lazy { nfs_client_services }
property :portmap_service, String, default: lazy { nfs_service_name('portmap') }
property :rpcbind_service, String, default: 'rpcbind'
property :statd_service, String, default: lazy { nfs_service_name('statd') }
property :lock_service, String, default: lazy { nfs_service_name('lock') }
property :server_service, String, default: lazy { nfs_service_name('server') }
property :idmap_service, String, default: lazy { nfs_service_name('idmap') }
property :statd_port, Integer, default: 32_765
property :statd_out_port, Integer, default: 32_766
property :mountd_port, Integer, default: 32_767
property :lockd_port, Integer, default: 32_768
property :rquotad_port, Integer, default: 32_769
property :threads, Integer, default: 8
property :nfs_v2, [String, nil], default: nil, equal_to: %w(yes no)
property :nfs_v3, [String, nil], default: nil, equal_to: %w(yes no)
property :nfs_v4, [String, nil], default: nil, equal_to: %w(yes no)
property :rquotad, String, default: 'no'
property :manage_lockd, [true, false], default: true
