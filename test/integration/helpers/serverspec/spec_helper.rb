require 'serverspec'
require_relative 'shared/services.rb'
require_relative 'shared/issues.rb'

# Set Serverspec to do local execution
set :backend, :exec

# CentOS 5.x needs /sbin added to the path for service checks to work 
set :path, '/sbin:$PATH'
