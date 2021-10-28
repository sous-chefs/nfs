# These services on centos/fedora are loaded lazily and wait until a
# connection is attempted to start so, manually start them here so that
# Kitchen can test for them

%w(rpcbind rpc-statd).each do |s|
  service s do
    action [:enable, :start]
    only_if { platform_family?('rhel', 'fedora') }
  end
end
