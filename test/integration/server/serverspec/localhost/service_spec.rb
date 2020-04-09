require 'spec_helper'

describe 'Server Tests' do
  include_examples 'services::portmap'
  include_examples 'services::statd'
  include_examples 'services::mountd'
  include_examples 'services::lockd'

  if os[:family] == 'redhat'
    include_examples 'services::nfs-client' if host_inventory[:platform_version].to_f >= 7.1
    include_examples 'services::nfs-server'
  end

  include_examples 'issues::server'

  context 'Export from attributes' do
    describe command("grep -Ec '^\"?/media\"? ' /etc/exports") do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match(/1\n/) }
    end
    describe command("exportfs | grep -c '^/media\\s'") do
      its(:exit_status) { should eq 0 }
      its(:stdout) { should match(/1\n/) }
    end
  end
end
