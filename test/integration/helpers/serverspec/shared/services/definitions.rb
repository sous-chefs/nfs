require_relative 'ports.rb'

shared_examples 'services::portmap' do
  context 'portmap', if: os['family'] == 'redhat' do
    describe service('portmap') do
      it { should be_enabled }
      it { should be_running }
    end
    
    include_examples 'ports::portmap'
  end

  context 'rpcbind', if: os['family'] == 'redhat' do
    describe service('rpcbind') do
      it { should be_enabled }
      it { should be_running }
    end
    
    include_examples 'ports::portmap'
  end
end

shared_examples 'services::statd' do
  context 'statd' do
    describe service('statd') do
      it { should be_enabled }
      it { should be_running }
    end
    
    include_examples 'ports::statd'
  end
end
