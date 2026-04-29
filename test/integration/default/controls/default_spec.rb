# frozen_string_literal: true

control 'nfs-client-01' do
  impact 1.0
  title 'NFS client packages are installed'

  packages =
    if os.debian?
      %w(nfs-common rpcbind)
    else
      %w(nfs-utils rpcbind)
    end

  packages.each do |package_name|
    describe package(package_name) do
      it { should be_installed }
    end
  end
end

control 'nfs-client-02' do
  impact 1.0
  title 'NFS client configuration is rendered'

  config_path =
    if os.name == 'debian'
      '/etc/default/nfs-common'
    elsif os.name == 'ubuntu' && os.release.to_f < 22.04
      '/etc/default/nfs-common'
    else
      '/etc/nfs.conf'
    end

  describe file(config_path) do
    it { should exist }
    its('mode') { should cmp '0644' }
  end
end

control 'nfs-client-03' do
  impact 1.0
  title 'NFS client services are enabled'

  %w(rpcbind rpc-statd).each do |service_name|
    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end
  end
end
