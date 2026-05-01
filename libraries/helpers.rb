# frozen_string_literal: true

require 'etc'

module Nfs
  module Cookbook
    module Helpers
      def nfs_packages
        return %w(nfs-common rpcbind) if platform_family?('debian')
        return %w(nfs-client nfs-kernel-server rpcbind) if platform_family?('suse')

        %w(nfs-utils rpcbind)
      end

      def nfs_server_packages
        platform_family?('debian') ? ['nfs-kernel-server'] : []
      end

      def nfs_client_config_paths
        if platform_family?('debian')
          return ['/etc/nfs.conf'] if platform?('ubuntu') && node['platform_version'].to_f >= 22.04

          ['/etc/default/nfs-common']
        elsif modern_nfs_conf?
          ['/etc/nfs.conf']
        else
          ['/etc/sysconfig/nfs']
        end
      end

      def nfs_server_config_path
        if platform_family?('debian')
          return '/etc/nfs.conf' if platform?('ubuntu') && node['platform_version'].to_f >= 22.04

          '/etc/default/nfs-kernel-server'
        elsif modern_nfs_conf?
          '/etc/nfs.conf'
        else
          '/etc/sysconfig/nfs'
        end
      end

      def nfs_template_source(config_path)
        case ::File.basename(config_path)
        when 'nfs.conf'
          'nfs.conf.erb'
        when 'nfs-common'
          'nfs-common.erb'
        else
          'nfs.erb'
        end
      end

      def nfs_client_services
        %w(portmap statd lock)
      end

      def nfs_service_name(component)
        services = {
          'portmap' => 'nfs-client.target',
          'statd' => 'rpc-statd.service',
          'lock' => platform_family?('suse') ? 'nfsserver' : 'nfs-client.target',
          'server' => platform_family?('debian') ? 'nfs-kernel-server.service' : 'nfs-server.service',
          'idmap' => 'nfs-idmapd.service',
        }

        services.fetch(component)
      end

      def nfs_pipefs_directory
        platform_family?('debian') ? '/run/rpc_pipefs' : '/var/lib/nfs/rpc_pipefs'
      end

      def nfs_idmap_group
        platform_family?('debian') ? 'nogroup' : 'nobody'
      end

      def nfs_export_line(directory:, network:, writeable:, sync:, options:, anonuser:, anongroup:, fsid:)
        export_options = nfs_export_options(writeable: writeable, sync: sync, options: options, anonuser: anonuser, anongroup: anongroup, fsid: fsid)
        networks = network.is_a?(Array) ? network : [network]
        host_permissions = networks.map { |net| "#{net}(#{export_options})" }

        "#{directory} #{host_permissions.join(' ')}"
      end

      def find_uid(username)
        uid = nil
        Etc.passwd do |entry|
          if entry.name == username
            uid = entry.uid
            break
          end
        end
        uid
      end

      def find_gid(groupname)
        gid = nil
        Etc.group do |entry|
          if entry.name == groupname
            gid = entry.gid
            break
          end
        end
        gid
      end

      private

      def modern_nfs_conf?
        platform_family?('fedora') || (platform_family?('rhel') && node['platform_version'].to_i >= 8) || platform_family?('amazon')
      end

      def nfs_export_options(writeable:, sync:, options:, anonuser:, anongroup:, fsid:)
        export_options = [
          writeable ? 'rw' : 'ro',
          sync ? 'sync' : 'async',
          *options,
        ]
        export_options << "anonuid=#{find_uid(anonuser)}" if anonuser
        export_options << "anongid=#{find_gid(anongroup)}" if anongroup
        export_options << "fsid=#{fsid}" if platform_family?('fedora')

        export_options.join(',')
      end
    end
  end
end
