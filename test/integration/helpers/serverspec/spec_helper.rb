require 'serverspec'
require_relative 'shared/services/definitions'
require_relative 'shared/issues'

# Set Serverspec to do local execution
set :backend, :exec

# CentOS 5.x needs /sbin added to the path for service checks to work
set :path, '/sbin:$PATH'
