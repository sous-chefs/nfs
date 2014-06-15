require 'spec_helper'

describe 'nfs::client4' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  %w(nfs::_common nfs::_idmap).each do |component|
    it "should include #{component}" do
      expect(chef_run).to include_recipe(component)
    end
  end

end
