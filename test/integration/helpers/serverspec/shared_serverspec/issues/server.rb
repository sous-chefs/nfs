require_relative 'issue-46.rb'

shared_examples "issues::server" do
  context "Server Regression Checks" do
    include_examples "issue-46"
  end
end
