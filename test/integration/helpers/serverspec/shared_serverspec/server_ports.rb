shared_examples "server_ports" do
  context "Portmap daemon" do
    describe port(111) do
      it { should be_listening.with('tcp') }
      it { should be_listening.with('udp') }
    end
  end

  context "Stat daemon" do
    describe port(32765) do
      it { should be_listening.with('tcp') }
    end
  end

  context "Mount daemon" do
    describe port(32767) do
      it { should be_listening.with('tcp') }
      it { should be_listening.with('udp') }
    end
  end

  context "Lock daemon" do
    describe port(32768) do
      it { should be_listening.with('tcp') }
      it { should be_listening.with('udp') }
    end
  end
end
