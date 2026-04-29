# nfs_export

Manages entries in `/etc/exports` and reloads the export table.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Adds or updates an export line (default) |
| `:delete` | Removes export lines for the directory |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `directory` | String | name property | Directory to export |
| `network` | String, Array | required | Client network, host, or wildcard |
| `writeable` | true, false | `false` | Uses `rw` when true, otherwise `ro` |
| `sync` | true, false | `true` | Uses `sync` when true, otherwise `async` |
| `options` | Array | `['root_squash']` | Additional export options |
| `anonuser` | String | `nil` | User name resolved to `anonuid` |
| `anongroup` | String | `nil` | Group name resolved to `anongid` |
| `unique` | true, false | `false` | Replaces existing directory export lines when true |
| `fsid` | String | `root` | Fedora-only fsid option |
| `exports_file` | String | `/etc/exports` | Exports file to manage |

## Examples

```ruby
nfs_export '/exports' do
  network '10.0.0.0/8'
  writeable false
  sync true
  options ['no_root_squash']
end
```

```ruby
nfs_export '/exports' do
  network %w(10.0.0.0/8 192.168.1.0/24)
  unique true
end
```
