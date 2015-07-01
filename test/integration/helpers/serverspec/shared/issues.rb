require_relative 'issues/issue_gh46.rb'

shared_examples 'issues::server' do
  context 'Server Regression Checks' do
    include_examples 'issues::gh46'
  end
end
