# nfs_server

Installs and configures NFS server packages, shared client components, server configuration, rpcbind, sysctl lockd ports, and the NFS server service.

## Actions

| Action    | Description                                                                 |
| --------- | --------------------------------------------------------------------------- |
| `:create` | Installs and configures the NFS server (default)                            |
| `:delete` | Stops services, removes managed config files, sysctl settings, and packages |

## Properties

| Property              | Type        | Default          | Description                                       |
| --------------------- | ----------- | ---------------- | ------------------------------------------------- |
| `packages`            | Array       | platform default | Shared client packages                            |
| `server_packages`     | Array       | platform default | Additional server packages                        |
| `client_config_paths` | Array       | platform default | Shared client config paths                        |
| `server_config_path`  | String      | platform default | Server config path                                |
| `server_service`      | String      | platform default | NFS server service                                |
| `manage_idmap`        | true, false | `false`          | Whether to manage `nfs_idmap` for NFSv4           |
| `manage_lockd`        | true, false | `true`           | Whether to manage lockd kernel module and sysctls |
| `statd_port`          | Integer     | `32765`          | statd listen port                                 |
| `statd_out_port`      | Integer     | `32766`          | statd outgoing port                               |
| `mountd_port`         | Integer     | `32767`          | mountd listen port                                |
| `lockd_port`          | Integer     | `32768`          | lockd TCP/UDP port                                |
| `rquotad_port`        | Integer     | `32769`          | rquotad port                                      |
| `threads`             | Integer     | `8`              | nfsd thread count                                 |
| `nfs_v2`              | String, nil | `nil`            | Optional NFSv2 setting, `yes` or `no`             |
| `nfs_v3`              | String, nil | `nil`            | Optional NFSv3 setting, `yes` or `no`             |
| `nfs_v4`              | String, nil | `nil`            | Optional NFSv4 setting, `yes` or `no`             |
| `rquotad`             | String      | `no`             | rquotad enablement value                          |

## Examples

```ruby
nfs_server 'default'
```

```ruby
nfs_server 'nfsv4' do
  manage_idmap true
  nfs_v4 'yes'
end
```
