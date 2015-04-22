require 'serverspec'
require_relative 'shared_serverspec/server_ports.rb'
require_relative 'shared_serverspec/redhat/server_services.rb'
require_relative 'shared_serverspec/issues/server.rb'

# Set Serverspec to do local execution
set :backend, :exec
