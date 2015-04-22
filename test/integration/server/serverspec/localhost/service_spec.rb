require 'spec_helper'
require 'shared_serverspec/redhat/server_services.rb'
require 'shared_serverspec/server_ports.rb'

describe "Server Tests" do
  include_examples 'redhat::server_services'
  include_examples 'server_ports'
end
