# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'nfs_server' do
  step_into :nfs_server

  context 'on ubuntu 24.04' do
    platform 'ubuntu', '24.04'

    recipe do
      nfs_server 'default' do
        manage_lockd false
      end
    end

    it { is_expected.to install_package('nfs-common') }
    it { is_expected.to install_package('rpcbind') }
    it { is_expected.to install_package('nfs-kernel-server') }
    it { is_expected.to enable_service('rpcbind') }
    it { is_expected.to start_service('rpcbind') }
    it { is_expected.to enable_service('nfs-kernel-server.service') }
    it { is_expected.to start_service('nfs-kernel-server.service') }

    it do
      is_expected.to render_file('/etc/nfs.conf')
        .with_content(/\[nfsd\]\nthreads=8/)
        .with_content(/\[mountd\]\nport=32767/)
    end
  end

  context 'on debian 12' do
    platform 'debian', '12'

    recipe do
      nfs_server 'default' do
        manage_lockd false
      end
    end

    it { is_expected.to create_template('/etc/default/nfs-common') }

    it do
      is_expected.to render_file('/etc/default/nfs-kernel-server')
        .with_content(/RPCMOUNTDOPTS="-p +32767"/)
        .with_content(/RPCNFSDCOUNT="8"/)
    end
  end

  context 'with idmap enabled' do
    platform 'ubuntu', '24.04'

    recipe do
      nfs_server 'default' do
        manage_idmap true
        manage_lockd false
      end
    end

    it { is_expected.to create_nfs_idmap('server default') }
  end

  context 'action :delete' do
    platform 'ubuntu', '24.04'

    recipe do
      nfs_server 'default' do
        manage_lockd false
        action :delete
      end
    end

    it { is_expected.to stop_service('nfs-kernel-server.service') }
    it { is_expected.to disable_service('nfs-kernel-server.service') }
    it { is_expected.to delete_file('/etc/nfs.conf') }
    it { is_expected.to remove_package('nfs-kernel-server') }
    it { is_expected.to remove_package('nfs-common') }
  end
end
