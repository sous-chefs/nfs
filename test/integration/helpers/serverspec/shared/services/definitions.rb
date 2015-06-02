require_relative 'ports.rb'

shared_examples 'services::portmap' do
  context 'portmap/rpcbind' do
    name = 'portmap'

    # RHEL/CentOS
    name = 'rpcbind' if (os[:family] == 'redhat' && host_inventory[:platform_version].to_i >= 6)
    name = '' if (os[:family] == 'redhat' && host_inventory[:platform_version].to_f >= 7.1)

    # Debian/Ubuntu
    name = 'rpcbind' if (host_inventory[:platform] == 'ubuntu' && host_inventory[:platform_version] == '14.04')
    name = 'rpcbind' if host_inventory[:platform] == 'debian'

    describe service(name) do
      it { should be_enabled }
      it { should be_running }
    end unless name == ''

    include_examples 'ports::portmap' unless name == ''
  end

  # RHEL/CentOS 7.1 does some strange things and we need to check for nfs-client.target.
  # At present, specinfra doesn't handle checking for *.target systemd units, so some
  # manual work is required.
  # It also lazy-starts some services at the first mount. I have not yet found a way
  # to reliably test NFS mounts.
  context 'nfs-client', if: ( os[:family] == 'redhat' ) do
    describe command('systemctl is-enabled nfs-client.target') do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should contain('enabled') }
    end
    describe service('nfs-client.target') do
      it { should be_running }
    end
  end
end

shared_examples 'services::statd' do
  context 'statd' do
    name = 'statd'

    # RHEL/CentOS
    name = 'nfslock' if os[:family] == 'redhat'
    name = 'nfs-lock' if (os[:family] == 'redhat' && host_inventory[:platform_version] == '7.0.1406')
    name = '' if (os[:family] == 'redhat' && host_inventory[:platform_version].to_f >= 7.1)

    name = 'nfs-common' if host_inventory[:platform] == 'debian'

    describe service(name) do
      it { should be_enabled }
      it { should be_running }
    end unless name == ''

    include_examples 'ports::statd' unless name == ''
  end
end
