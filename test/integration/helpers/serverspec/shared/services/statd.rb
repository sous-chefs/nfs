shared_examples 'ports::statd' do
  context 'statd' do
    describe port(32765) do
      it { should be_listening.with('tcp') }
    end
  end
end

shared_examples 'services::statd' do
  context 'statd' do
    name = 'nfslock'
    check_enabled = true
    check_running = true

    # RHEL/CentOS
    if os[:family] == 'redhat'
      name = 'nfslock' if host_inventory[:platform_version].to_i == 5
      check_enabled = false if host_inventory[:platform_version].to_i == 6

      # In 7.0 the statd process is managed by the nfs-lock service
      name = 'nfs-lock' if host_inventory[:platform_version].to_f >= 7.0

      if host_inventory[:platform_version].to_f >= 7.1
        name = 'rpc-statd'
        # Due to lazy-starting services, this needs a kick to wake up
        describe command("systemctl start #{name}") do
          its(:exit_status) { should eq 0 }
        end
        check_enabled = false
      end
    elsif os[:family] == 'amazon'
      name = 'nfslock'
    end


    name = 'nfs-common' if host_inventory[:platform] == 'debian'
    name = 'statd' if host_inventory[:platform] == 'ubuntu'
    name = 'nfsserver' if host_inventory[:platform] == 'suse'

    describe service(name) do
      it { should be_enabled } if check_enabled
      it { should be_running } if check_running
    end unless name == ''

    include_examples 'ports::statd' # unless name == ''
  end
end
