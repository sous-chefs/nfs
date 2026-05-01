# nfs_client

Installs and configures NFS client packages, client configuration files, lockd settings, rpcbind, and client services.

## Actions

| Action    | Description                                                        |
| --------- | ------------------------------------------------------------------ |
| `:create` | Installs and configures the NFS client (default)                   |
| `:delete` | Stops services, removes managed config files, and removes packages |

## Properties

| Property              | Type        | Default                  | Description                                   |
| --------------------- | ----------- | ------------------------ | --------------------------------------------- |
| `packages`            | Array       | platform default         | Packages to install                           |
| `client_config_paths` | Array       | platform default         | Client config files to render                 |
| `client_services`     | Array       | `%w(portmap statd lock)` | Logical client services                       |
| `portmap_service`     | String      | platform default         | Portmap/client target service                 |
| `rpcbind_service`     | String      | `rpcbind`                | rpcbind service                               |
| `statd_service`       | String      | `rpc-statd.service`      | statd service                                 |
| `lock_service`        | String      | platform default         | lock service                                  |
| `statd_port`          | Integer     | `32765`                  | statd listen port                             |
| `statd_out_port`      | Integer     | `32766`                  | statd outgoing port                           |
| `mountd_port`         | Integer     | `32767`                  | mountd listen port rendered into config       |
| `lockd_port`          | Integer     | `32768`                  | lockd TCP/UDP port                            |
| `rquotad_port`        | Integer     | `32769`                  | rquotad port rendered into config             |
| `threads`             | Integer     | `8`                      | nfsd thread count rendered into shared config |
| `nfs_v2`              | String, nil | `nil`                    | Optional NFSv2 setting, `yes` or `no`         |
| `nfs_v3`              | String, nil | `nil`                    | Optional NFSv3 setting, `yes` or `no`         |
| `nfs_v4`              | String, nil | `nil`                    | Optional NFSv4 setting, `yes` or `no`         |
| `rquotad`             | String      | `no`                     | rquotad enablement value                      |
| `manage_lockd`        | true, false | `true`                   | Whether to manage the lockd kernel module     |

## Examples

```ruby
nfs_client 'default'
```

```ruby
nfs_client 'custom ports' do
  statd_port 32_765
  statd_out_port 32_766
  mountd_port 32_767
  lockd_port 32_768
end
```
