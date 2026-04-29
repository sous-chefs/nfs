# nfs_idmap

Manages the NFSv4 idmap configuration file and idmap service.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Renders idmap configuration and starts the service (default) |
| `:delete` | Stops the service and removes the config file |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `config_path` | String | `/etc/idmapd.conf` | idmap config path |
| `domain` | String | `node['domain']` | NFSv4 idmap domain |
| `pipefs_directory` | String | platform default | rpc pipefs directory |
| `user` | String | `nobody` | Nobody user mapping |
| `group` | String | platform default | Nobody group mapping |
| `idmap_service` | String | `nfs-idmapd.service` | idmap service |

## Examples

```ruby
nfs_idmap 'default'
```

```ruby
nfs_idmap 'example domain' do
  domain 'example.test'
end
```
