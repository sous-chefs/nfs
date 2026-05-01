# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'nfs_client' do
  step_into :nfs_client

  context 'on ubuntu 24.04' do
    platform 'ubuntu', '24.04'

    recipe do
      nfs_client 'default' do
        manage_lockd false
      end
    end

    it { is_expected.to install_package('nfs-common') }
    it { is_expected.to install_package('rpcbind') }
    it { is_expected.to enable_service('rpcbind') }
    it { is_expected.to start_service('rpcbind') }
    it { is_expected.to enable_service('nfs-client.target') }
    it { is_expected.to start_service('nfs-client.target') }
    it { is_expected.to enable_service('rpc-statd.service') }
    it { is_expected.to start_service('rpc-statd.service') }

    it do
      is_expected.to render_file('/etc/nfs.conf')
        .with_content(/\[statd\]\nport=32765\noutgoing-port=32766/)
        .with_content(/\[mountd\]\nport=32767/)
        .with_content(/\[lockd\]\nport=32768\nudp-port=32768/)
    end
  end

  context 'on debian 12' do
    platform 'debian', '12'

    recipe do
      nfs_client 'default' do
        manage_lockd false
      end
    end

    it { is_expected.to install_package('nfs-common') }
    it { is_expected.to install_package('rpcbind') }

    it do
      is_expected.to render_file('/etc/default/nfs-common')
        .with_content(/STATDOPTS="--port 32765 --outgoing-port 32766"/)
    end
  end

  context 'action :delete' do
    platform 'ubuntu', '24.04'

    recipe do
      nfs_client 'default' do
        manage_lockd false
        action :delete
      end
    end

    it { is_expected.to stop_service('rpcbind') }
    it { is_expected.to disable_service('rpcbind') }
    it { is_expected.to delete_file('/etc/nfs.conf') }
    it { is_expected.to remove_package('nfs-common') }
    it { is_expected.to remove_package('rpcbind') }
  end
end
