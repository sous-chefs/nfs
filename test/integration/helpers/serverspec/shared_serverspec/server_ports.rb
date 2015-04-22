shared_examples "server_ports" do
  describe "NFS Server Ports" do
    describe port(32678) do
      it { should be_listening.with('tcp') }
      it { should be_listening.with('udp') }
    end
  end
end
