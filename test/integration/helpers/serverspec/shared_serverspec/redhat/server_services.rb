shared_examples "redhat::server_services" do
  describe "NFS Server Services" do
    context "RHEL", if: os['family'] == 'redhat' do
      context "6.x", if: host_inventory['platform_version'].to_i == 6 do
        describe service('rpcbind') do
          it { should be_enabled }
          it { should be_running }
        end

        describe service('nfslock') do
          it { should be_enabled }
          it { should be_running }
        end

        describe service('nfs') do
          it { should be_enabled }
          it { should be_running }
        end
      end

      describe "7.0", if: host_inventory['platform_version'].to_f == 7.0 do
        describe service('nfs-lock') do
          it { should be_enabled }
          it { should be_running }
        end

        describe service('nfs-server') do
          it { should be_enabled }
          it { should be_running }
        end
      end

      describe "7.1+", if: host_inventory['platform_version'].to_f >= 7.1 do
        describe service('nfs-server') do
          it { should be_enabled }
          it { should be_running }
        end

        describe service('rpcbind.target') do
          it { should be_running }
        end

        describe service('rpc-statd') do
          it { should be_running }
        end

        describe service('nfs-mountd') do
          it { should be_running }
        end
      end
    end
  end
end
