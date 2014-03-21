nfs_export '/tmp' do
  network '127.0.0.0/8'
  writeable false
  sync true
  options ['no_root_squash']
end

directory '/mnt/test'

mount '/mnt/test' do
  device '127.0.0.1:/tmp'
  fstype 'nfs'
end
