# frozen_string_literal: true

require_relative '../../spec_helper'

describe 'nfs_export' do
  step_into :nfs_export
  platform 'ubuntu', '24.04'

  context 'with a single network' do
    recipe do
      nfs_export '/srv/share' do
        network '10.0.0.0/8'
        writeable true
        options %w(no_root_squash)
      end
    end

    it { is_expected.to create_file_if_missing('/etc/exports') }
    it { is_expected.to nothing_execute('exportfs') }

    it do
      is_expected.to edit_append_if_no_line('export /srv/share')
        .with(path: '/etc/exports', line: '/srv/share 10.0.0.0/8(rw,sync,no_root_squash)')
    end
  end

  context 'with unique replacement enabled' do
    recipe do
      nfs_export '/srv/share' do
        network %w(10.0.0.0/8 192.168.1.0/24)
        unique true
      end
    end

    it do
      is_expected.to edit_replace_or_add('export /srv/share')
        .with(path: '/etc/exports', line: '/srv/share 10.0.0.0/8(ro,sync,root_squash) 192.168.1.0/24(ro,sync,root_squash)')
    end
  end

  context 'action :delete' do
    recipe do
      nfs_export '/srv/share' do
        network '10.0.0.0/8'
        action :delete
      end
    end

    it { is_expected.to edit_delete_lines('export /srv/share').with(path: '/etc/exports') }
  end
end
