# these services on centos are loaded lazily and wait until a connection is attempted to start
# so, manually start them here so that Kitchen can test for them

# need to shell out to systemctl since service resource won't actually start them

execute 'force start nfs services' do
  command 'systemctl start rpcbind rpc-statd'
  only_if { platform_family?('rhel') }
end
