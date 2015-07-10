shared_examples "ports::portmap" do
  context "portmap/rpcbind" do
    describe port(111) do
      it { should be_listening.with('tcp') }
      it { should be_listening.with('udp') }
    end
  end
end

shared_examples 'services::portmap' do
  context 'portmap/rpcbind' do
    name = 'portmap'
    check_enabled = true
    check_running = true

    # RHEL/CentOS
    if os[:family] == 'redhat'
      name = 'rpcbind' if host_inventory[:platform_version].to_i >= 6

      if host_inventory[:platform_version].to_f >= 7.1
        name = 'rpcbind'
        # Due to lazy-starting services, this needs a kick to wake up
        describe command("systemctl start #{name}") do
          its(:exit_status) { should eq 0 }
        end
        check_enabled = false
      end
    end

    if os[:family] == 'amazon'
      name = 'rpcbind'
    end

    # Debian/Ubuntu
    name = 'rpcbind' if (host_inventory[:platform] == 'ubuntu' && host_inventory[:platform_version] == '14.04')
    name = 'rpcbind' if host_inventory[:platform] == 'debian'

    describe service(name) do
      it { should be_enabled } if check_enabled
      it { should be_running } if check_running
    end unless name == ''

    include_examples 'ports::portmap' # unless name == ''
  end
end
