require_relative '../../spec_helper'

describe 'nfs::_common' do
  context 'on centos' do
    platform 'centos'

    it { is_expected.to install_package('nfs-utils') }
    it { is_expected.to install_package('rpcbind') }

    it { is_expected.to start_service('nfs-client.target') }
    it { is_expected.to enable_service('nfs-client.target') }

    it do
      is_expected.to render_file('/etc/sysconfig/nfs')
        .with_content(/STATD_PORT="32765"/)
        .with_content(/STATD_OUTGOING_PORT="32766"/)
        .with_content(/MOUNTD_PORT="32767"/)
        .with_content(/LOCKD_UDPPORT="32768"/)
        .with_content(/RPCNFSDCOUNT="8"/)
    end
  end

  context 'on debian' do
    platform 'debian'

    it { is_expected.to install_package('nfs-common') }
    it { is_expected.to install_package('rpcbind') }

    it { is_expected.to start_service('nfs-client.target') }
    it { is_expected.to enable_service('nfs-client.target') }

    it do
      is_expected.to render_file('/etc/default/nfs-common')
        .with_content(/STATDOPTS="--port 32765 --outgoing-port 32766"/)
    end
  end
end
