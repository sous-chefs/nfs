# Migration Guide

## Breaking Change

The `nfs` cookbook is now a custom-resource cookbook. The legacy `recipes/` and `attributes/` APIs have been removed.

Replace run list entries such as `recipe[nfs]`, `recipe[nfs::client4]`, `recipe[nfs::server]`, `recipe[nfs::server4]`, and `recipe[nfs::undo]` with explicit resource declarations in your own cookbook.

## Recipe Replacements

### `nfs::default`

```ruby
nfs_client 'default'
```

### `nfs::client4`

```ruby
nfs_client 'default'
nfs_idmap 'default'
```

### `nfs::server`

```ruby
nfs_server 'default'
```

### `nfs::server4`

```ruby
nfs_server 'default' do
  manage_idmap true
end
```

### `nfs::undo`

```ruby
nfs_server 'default' do
  action :delete
end
```

Use `nfs_client 'default' { action :delete }`, `nfs_idmap 'default' { action :delete }`, and `nfs_export '/path' { action :delete }` when you only need to remove a specific layer.

## Attribute Replacements

Node attributes such as `node['nfs']['packages']`, `node['nfs']['port']['statd']`, `node['nfs']['threads']`, and `node['nfs']['idmap']['domain']` are now resource properties.

```ruby
nfs_server 'default' do
  packages %w(nfs-utils rpcbind)
  statd_port 32_765
  statd_out_port 32_766
  mountd_port 32_767
  lockd_port 32_768
  threads 16
end

nfs_idmap 'default' do
  domain 'example.test'
  user 'nobody'
  group 'nobody'
end
```

## Test Cookbook Examples

See `test/cookbooks/test/recipes/default.rb` for client usage and `test/cookbooks/test/recipes/server.rb` for server, idmap, and export usage.
