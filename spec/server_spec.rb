require 'spec_helper'

describe 'nfs::server' do
  shared_examples 'debian family' do
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

  %w(5.11 6.10 8).each do |release|
    context "on Centos #{release}" do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new(platform: 'centos', version: release).converge(described_recipe)
      end

      case release
      when '5.11', '6.10'
        %w(nfs).each do |svc|
          it "starts the #{svc} service" do
            expect(chef_run).to start_service(svc)
          end

          it "enables the #{svc} service" do
            expect(chef_run).to enable_service(svc)
          end
        end
      when '8'
        %w(nfs-server).each do |svc|
          it "starts the #{svc} service" do
            expect(chef_run).to start_service(svc)
          end

          it "enables the #{svc} service" do
            expect(chef_run).to enable_service(svc)
          end
        end
      end
    end
  end

  context 'on FreeBSD 11.2' do
    cached(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'freebsd', version: '11.2').converge(described_recipe)
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

  %w(16.04 18.04).each do |release|
    # Submit Ubuntu Fauxhai to https://github.com/customink/fauxhai for better Ubuntu coverage
    context "on Ubuntu #{release}" do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new(platform: 'ubuntu', version: release).converge(described_recipe)
      end

      it 'creates file /etc/default/nfs-kernel-server with: RPCMOUNTDOPTS="-p 32767"' do
        expect(chef_run).to render_file('/etc/default/nfs-kernel-server').with_content(/RPCMOUNTDOPTS="-p +32767"/)
      end

      include_examples 'debian family'

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

  %w(8.11 9.11 10).each do |release|
    context "on Debian #{release}" do
      cached(:chef_run) do
        ChefSpec::ServerRunner.new(platform: 'debian', version: release).converge(described_recipe)
      end

      it 'creates file /etc/default/nfs-kernel-server with: RPCMOUNTDOPTS="-p 32767"' do
        expect(chef_run).to render_file('/etc/default/nfs-kernel-server').with_content(/RPCMOUNTDOPTS="-p +32767"/)
      end

      it 'creates file /etc/default/nfs-kernel-server with: RPCNFSDCOUNT="8"' do
        expect(chef_run).to render_file('/etc/default/nfs-kernel-server').with_content(/RPCNFSDCOUNT="8"/)
      end

      include_examples 'debian family'
    end
  end
end
