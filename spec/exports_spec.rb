require 'spec_helper'

def solo_runner_with_exports(exports, unexports = {})
  ChefSpec::SoloRunner.new(
    platform: 'debian',
    version: '9.11',
    step_into: %w(nfs_export)
  ) do |node|
    node.normal['nfs']['exports'] = exports || {}
    node.normal['nfs']['unexports'] = unexports || {}
  end.converge(described_recipe)
end

def test_exports_content(regex)
  it 'creates valid contents for /etc/exports' do
    expect(chef_run).to render_file('/etc/exports').with_content(
      Regexp.new(/^(#[^\n]*\n)+/.source + regex.source + '$')
    )
  end
end

describe 'nfs::_exports' do
  shared_examples 'default_behavior' do
    it 'updates /etc/exports' do
      expect(chef_run).to create_template('/etc/exports')
      expect(chef_run).to render_file('/etc/exports').with_content(
        start_with('# Generated by Chef')
      )
    end
    it 'executes exportfs -ar' do
      expect(chef_run.template('/etc/exports')).to notify('execute[exportfs]').to(:run)
    end
  end

  describe 'accepts array values' do
    cached(:chef_run) do
      solo_runner_with_exports(
        '/share' => %w(127.0.0.1 192.168.0.*)
      )
    end
    test_exports_content(
      %r{("?/share"? [^(]+\([^)]*\)\n?){2}}
    )
    include_examples 'default_behavior'
  end

  describe 'accepts hash values' do
    cached(:chef_run) do
      solo_runner_with_exports(
        '/share' => {
          'network' => %w(127.0.0.1 192.168.0.1),
          'options' => %w(no_root_squash),
        }
      )
    end
    it 'creates valid contents for /etc/exports' do
      render_exports = render_file('/etc/exports')
      [
        %r{^"?/share"? 127\.0\.0\.1\(no_root_squash,ro,sync\)$},
        %r{^"?/share"? 192\.168\.0\.1\(no_root_squash,ro,sync\)$},
      ].each do |content|
        render_exports.with_content(content)
      end
      expect(chef_run).to render_exports
    end
    include_examples 'default_behavior'
  end

  describe 'accepts nil value' do
    cached(:chef_run) do
      solo_runner_with_exports('/share' => nil)
    end
    test_exports_content(
      %r{"?/share"? \*\([^)]*\)}
    )
    include_examples 'default_behavior'
  end

  describe 'accepts string values' do
    cached(:chef_run) do
      solo_runner_with_exports(
        '/share' => '127.0.0.1'
      )
    end
    test_exports_content(
      %r{"?/share"? 127\.0\.0\.1\([^)]*\)}
    )
    include_examples 'default_behavior'
  end

  describe 'honors special attributes' do
    cached(:chef_run) do
      solo_runner_with_exports(
        '/share' => {
          'network' => %w(*),
          'options' => [],
          'writeable' => true,
          'sync' => false,
          'anonuser' => 0,
          'anongroup' => 0,
        }
      )
    end
    test_exports_content(
      %r{"?/share"? \*\(anongid=0,anonuid=0,async,rw\)}
    )
    include_examples 'default_behavior'
  end

  describe 'merges options from resource and hash' do
    cached(:chef_run) do
      solo_runner_with_exports(
        '/share' => {
          '127.0.0.1' => 'subtree_check',
          'options' => 'root_squash',
          'sync' => false,
        }
      )
    end
    test_exports_content(
      %r{"?/share"? 127\.0\.0\.1\(async,ro,root_squash,subtree_check\)}
    )
    include_examples 'default_behavior'
  end

  describe 'sorts exports for the same directory' do
    cached(:chef_run) do
      solo_runner_with_exports(
        '/share' => {
          'network' => %w(192.168.* * 192.168.0.1),
        }
      )
    end
    test_exports_content(
      %r{"?/share"? 192\.168\.0\.1\([^)]*\)\n"?/share"? 192\.168\.\*\([^)]*\)\n"?/share"? \*\([^)]*\)}
    )
    include_examples 'default_behavior'
  end

  describe 'removes unexports' do
    cached(:chef_run) do
      solo_runner_with_exports(
        { '/share' => %w(127.0.0.1 192.168.0.1) },
        '/share' => '127\.0\.0\..*'
      )
    end
    test_exports_content(
      %r{"?/share"? 192.168.0.1\([^)]*\)}
    )
    include_examples 'default_behavior'
  end
end
