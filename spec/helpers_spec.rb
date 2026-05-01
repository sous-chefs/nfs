# frozen_string_literal: true

require_relative 'spec_helper'

describe Nfs::Cookbook::Helpers do
  let(:helper_class) do
    Class.new do
      include Nfs::Cookbook::Helpers

      attr_accessor :node

      def platform_family?(*families)
        families.include?(node['platform_family'])
      end

      def platform?(*platforms)
        platforms.include?(node['platform'])
      end
    end
  end

  let(:helper) { helper_class.new }

  before do
    helper.node = {
      'platform' => 'ubuntu',
      'platform_family' => 'debian',
      'platform_version' => '24.04',
    }
  end

  it 'returns Ubuntu 24.04 nfs.conf client defaults' do
    expect(helper.nfs_client_config_paths).to eq(['/etc/nfs.conf'])
  end

  it 'builds export lines for multiple networks' do
    expect(
      helper.nfs_export_line(
        directory: '/srv/share',
        network: %w(10.0.0.0/8 192.168.1.0/24),
        writeable: false,
        sync: true,
        options: ['root_squash'],
        anonuser: nil,
        anongroup: nil,
        fsid: 'root'
      )
    ).to eq('/srv/share 10.0.0.0/8(ro,sync,root_squash) 192.168.1.0/24(ro,sync,root_squash)')
  end
end
