require 'chefspec'
require 'chefspec/berkshelf'

config.log_level = :error

at_exit { ChefSpec::Coverage.report! }
