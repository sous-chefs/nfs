shared_examples "ports::portmap" do
  context "portmap/rpcbind" do
    describe port(111) do
      it { should be_listening.with('tcp') }
      it { should be_listening.with('udp') }
    end
  end
end

shared_examples "ports::statd" do
  context "statd" do
    describe port(32765) do
      it { should be_listening.with('tcp') }
    end
  end
end

shared_examples "ports::mountd" do
  context "mountd" do
    describe port(32767) do
      it { should be_listening.with('tcp') }
      it { should be_listening.with('udp') }
    end
  end
end

shared_examples "ports::lockd" do
  context "lockd" do
    describe port(32768) do
      it { should be_listening.with('tcp') }
      it { should be_listening.with('udp') }
    end
  end
end
