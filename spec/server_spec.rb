require 'spec_helper'

describe 'nfs::server' do
  context 'on Centos 5.11' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: 5.11).converge(described_recipe)
    end

    it 'includes recipe nfs::_common' do
      expect(chef_run).to include_recipe('nfs::_common')
    end

    %w(nfs).each do |svc|
      it "starts the #{svc} service" do
        expect(chef_run).to start_service(svc)
      end

      it "enables the #{svc} service" do
        expect(chef_run).to enable_service(svc)
      end
    end
  end

  context 'on Centos 6.8' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'centos', version: 6.8).converge(described_recipe)
    end

    it 'includes recipe nfs::_common' do
      expect(chef_run).to include_recipe('nfs::_common')
    end

    %w(nfs).each do |svc|
      it "starts the #{svc} service" do
        expect(chef_run).to start_service(svc)
      end

      it "enables the #{svc} service" do
        expect(chef_run).to enable_service(svc)
      end
    end
  end

  context 'on Amazon 2014.09' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'amazon', version: 2014.09).converge(described_recipe)
    end

    it 'includes recipe nfs::_common' do
      expect(chef_run).to include_recipe('nfs::_common')
    end

    %w(nfs).each do |svc|
      it "starts the #{svc} service" do
        expect(chef_run).to start_service(svc)
      end

      it "enables the #{svc} service" do
        expect(chef_run).to enable_service(svc)
      end
    end
  end

  context 'on FreeBSD' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'freebsd', version: 9.3).converge(described_recipe)
    end

    it 'includes recipe nfs::_common' do
      expect(chef_run).to include_recipe('nfs::_common')
    end

    %w(nfsd).each do |svc|
      it "starts the #{svc} service" do
        expect(chef_run).to start_service(svc)
      end

      it "enables the #{svc} service" do
        expect(chef_run).to enable_service(svc)
      end
    end

    it 'creates /etc/rc.conf.d/mountd with mountd flags -r -p 32767' do
      expect(chef_run).to render_file('/etc/rc.conf.d/mountd').with_content(/mountd_flags="?-r +-p +32767"?/)
    end

    it 'creates /etc/rc.conf.d/nfsd with server flags -u -t -n 24' do
      expect(chef_run).to render_file('/etc/rc.conf.d/nfsd').with_content(/server_flags="?-u +-t +-n +24"?/)
    end
  end

  %w(16.04 14.04 12.04).each do |release|
    # Submit Ubuntu Fauxhai to https://github.com/customink/fauxhai for better Ubuntu coverage
    context "on Ubuntu #{release}" do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new(platform: 'ubuntu', version: release).converge(described_recipe)
      end

      it 'includes recipe nfs::_common' do
        expect(chef_run).to include_recipe('nfs::_common')
      end

      it 'creates file /etc/default/nfs-kernel-server with: RPCMOUNTDOPTS="-p 32767"' do
        expect(chef_run).to render_file('/etc/default/nfs-kernel-server').with_content(/RPCMOUNTDOPTS="-p +32767"/)
      end

      %w(nfs-kernel-server).each do |nfs|
        it "installs package #{nfs}" do
          expect(chef_run).to install_package(nfs)
        end

        it "starts the #{nfs} service" do
          expect(chef_run).to start_service(nfs)
        end

        it "enables the #{nfs} service" do
          expect(chef_run).to enable_service(nfs)
        end
      end
    end
  end

  context 'on Debian 7.2' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'debian', version: 7.2).converge(described_recipe)
    end

    it 'includes recipe nfs::_common' do
      expect(chef_run).to include_recipe('nfs::_common')
    end

    it 'creates file /etc/default/nfs-kernel-server with: RPCMOUNTDOPTS="-p 32767"' do
      expect(chef_run).to render_file('/etc/default/nfs-kernel-server').with_content(/RPCMOUNTDOPTS="-p +32767"/)
    end

    it 'creates file /etc/default/nfs-kernel-server with: RPCNFSDCOUNT="8"' do
      expect(chef_run).to render_file('/etc/default/nfs-kernel-server').with_content(/RPCNFSDCOUNT="8"/)
    end

    %w(nfs-kernel-server).each do |nfs|
      it "installs package #{nfs}" do
        expect(chef_run).to install_package(nfs)
      end

      it "starts the #{nfs} service" do
        expect(chef_run).to start_service(nfs)
      end

      it "enables the #{nfs} service" do
        expect(chef_run).to enable_service(nfs)
      end
    end
  end

  context 'on Debian 8.2' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'debian', version: 8.2).converge(described_recipe)
    end

    it 'includes recipe nfs::_common' do
      expect(chef_run).to include_recipe('nfs::_common')
    end

    it 'creates file /etc/default/nfs-kernel-server with: RPCMOUNTDOPTS="-p 32767"' do
      expect(chef_run).to render_file('/etc/default/nfs-kernel-server').with_content(/RPCMOUNTDOPTS="-p +32767"/)
    end

    it 'creates file /etc/default/nfs-kernel-server with: RPCNFSDCOUNT="8"' do
      expect(chef_run).to render_file('/etc/default/nfs-kernel-server').with_content(/RPCNFSDCOUNT="8"/)
    end

    %w(nfs-kernel-server).each do |nfs|
      it "installs package #{nfs}" do
        expect(chef_run).to install_package(nfs)
      end

      it "starts the #{nfs} service" do
        expect(chef_run).to start_service(nfs)
      end

      it "enables the #{nfs} service" do
        expect(chef_run).to enable_service(nfs)
      end
    end
  end
end
