shared_examples "ports::lockd" do
  context "lockd" do
    describe port(32768) do
      it { should be_listening.with('tcp') }
      it { should be_listening.with('udp') }
    end
  end
end

shared_examples 'services::lockd' do
  context 'lockd' do
    name = 'lockd'
    check_enabled = true
    check_running = true

    # RHEL/CentOS
    if os[:family] == 'redhat'
      name = 'nfslock' if host_inventory[:platform_version].to_i == 6
      name = 'nfs-lock' if host_inventory[:platform_version].to_f >= 7.0
      # This seems to be a kernel process in 7.1
      if host_inventory[:platform_version].to_f >= 7.1
        check_enabled = false
        check_running = false
        describe process('lockd') do
          it { should be_running }
        end
      end
    end

    # name = 'nfs-common' if host_inventory[:platform] == 'debian'

    describe service(name) do
      it { should be_enabled } if check_enabled
      it { should be_running } if check_running
    end unless name == ''

    include_examples 'ports::lockd' if host_inventory[:platform_family] == 'redhat'
  end
end
