nfs_export "/tmp" do
  network "10.0.0.0/8"
  writeable false
  sync true
  options ['no_root_squash']
end

include_recipe "nfs::server"
