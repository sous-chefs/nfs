shared_examples "issue-46" do
  context "Issue #46" do
    context "Uniform anonuid/anongid on unrelated shares" do
      describe command("egrep -c '/tmp/share[0-9] 127.0.0.1\\(ro,sync,root_squash,anonuid=[0-9]+,anongid=[0-9]+\\)' /etc/exports") do
        its(:stdout) { should match /3\n/ }
      end
    end

    context "Unrelated shares are not stairstepping anonuid/anongid" do
      describe command("egrep -v '/tmp/share[0-9] 127.0.0.1\\(rw,sync,root_squash,(anonuid=[0-9]+,anongid=[0-9]+){2,}\\)' /etc/exports") do
        its(:exit_status) { should eq 0 }
        its(:stdout) { should_not contain('anonuid=1001').after('share2') }
        its(:stdout) { should_not contain('anongid=1001').after('share2') }
        its(:stdout) { should_not contain('anonuid=1002').after('share3') }
        its(:stdout) { should_not contain('anongid=1002').after('share3') }
      end
    end
  end
end
