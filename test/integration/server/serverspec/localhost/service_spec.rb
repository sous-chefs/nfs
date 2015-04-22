require 'spec_helper'

describe "Server Tests" do
  include_examples 'issues::server'
  include_examples 'server_ports'
  include_examples 'redhat::server_services'
end
