# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'nfs_idmap' do
  step_into :nfs_idmap
  platform 'debian', '12'

  context 'action :create' do
    recipe do
      nfs_idmap 'default' do
        domain 'example.test'
      end
    end

    it { is_expected.to enable_service('nfs-idmapd.service') }
    it { is_expected.to start_service('nfs-idmapd.service') }

    it do
      is_expected.to render_file('/etc/idmapd.conf')
        .with_content(%r{Pipefs-Directory = /run/rpc_pipefs})
        .with_content(/Domain = example\.test/)
        .with_content(/Nobody-User = nobody/)
        .with_content(/Nobody-Group = nogroup/)
    end
  end

  context 'with no node domain' do
    recipe do
      node.automatic['domain'] = nil

      nfs_idmap 'default'
    end

    it do
      is_expected.to render_file('/etc/idmapd.conf')
        .with_content(/Domain = localdomain/)
    end
  end

  context 'action :delete' do
    recipe do
      nfs_idmap 'default' do
        action :delete
      end
    end

    it { is_expected.to stop_service('nfs-idmapd.service') }
    it { is_expected.to disable_service('nfs-idmapd.service') }
    it { is_expected.to delete_file('/etc/idmapd.conf') }
  end
end
