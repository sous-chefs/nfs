Dir.glob('issues/**/*.rb') { |f| require_relative f }

shared_examples 'issues::server' do
  context 'Server Regression Checks' do
    include_examples 'issue-46'
  end
end
