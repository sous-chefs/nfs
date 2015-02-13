require 'spec_helper'

describe 'nfs::default' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'centos', version: 6.5).converge(described_recipe)
  end

  it 'should include nfs::_common' do
    expect(chef_run).to include_recipe('nfs::_common')
  end
end
