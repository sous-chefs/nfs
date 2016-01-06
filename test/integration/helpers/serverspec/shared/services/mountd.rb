shared_examples 'ports::mountd' do
  context 'mountd' do
    describe port(32_767) do
      it { should be_listening.with('tcp') }
      it { should be_listening.with('udp') }
    end
  end
end

shared_examples 'services::mountd' do
  context 'mountd' do
    name = 'mountd'
    check_enabled = true
    check_running = true

    # RHEL/CentOS
    if os[:family] == 'redhat'
      check_enabled = false
      name = 'nfs-mountd' if host_inventory[:platform_version].to_f >= 7.0
    elsif os[:family] == 'amazon'
      check_enabled = false
    elsif %w(debian ubuntu).include?(os[:family])
      name = 'nfs-kernel-server'
    end

    name = 'nfsserver' if os[:family] == 'suse'

    describe service(name) do
      it { should be_enabled } if check_enabled
      it { should be_running } if check_running
    end unless name == ''

    include_examples 'ports::mountd' if check_running
  end
end
