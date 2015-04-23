require 'serverspec'
require_relative 'shared/services.rb'
require_relative 'shared/issues.rb'

# Set Serverspec to do local execution
set :backend, :exec
