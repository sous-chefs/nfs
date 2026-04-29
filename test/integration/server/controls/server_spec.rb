# frozen_string_literal: true

include_controls 'default'

control 'nfs-server-01' do
  impact 1.0
  title 'NFS server package and service are installed'

  server_package = os.debian? ? 'nfs-kernel-server' : 'nfs-utils'
  server_service = os.debian? ? 'nfs-kernel-server' : 'nfs-server'

  describe package(server_package) do
    it { should be_installed }
  end

  describe service(server_service) do
    it { should be_enabled }
    it { should be_running }
  end
end

control 'nfs-server-02' do
  impact 1.0
  title 'Exports are rendered with anonymous user and group mappings'

  describe file('/etc/exports') do
    it { should exist }
    its('content') { should match(%r{^/tmp/share1 127\.0\.0\.1\(ro,sync,root_squash,anonuid=[0-9]+,anongid=[0-9]+(,fsid=root)?\)$}) }
    its('content') { should match(%r{^/tmp/share2 127\.0\.0\.1\(ro,sync,root_squash,anonuid=[0-9]+,anongid=[0-9]+(,fsid=root)?\)$}) }
    its('content') { should match(%r{^/tmp/share3 127\.0\.0\.1\(ro,sync,root_squash,anonuid=[0-9]+,anongid=[0-9]+(,fsid=root)?\)$}) }
  end
end

control 'nfs-server-03' do
  impact 1.0
  title 'NFS idmap configuration is rendered'

  describe file('/etc/idmapd.conf') do
    it { should exist }
    its('content') { should match(/Nobody-User = nobody/) }
  end
end
