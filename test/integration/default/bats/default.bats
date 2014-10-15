#!/usr/bin/env bats

@test 'portmap appears to be listening on TCP 111' {
  netstat -lun|grep :111
}

@test 'portmap appears to be listening on UDP 111' {
  netstat -lun|grep :111
}

@test 'statd appears to be listening on TCP 32765' {
  netstat -ltn|grep :32765
}

@test 'portmap or rpcbind is running' {
  pgrep rpcbind||pgrep portmap
}

@test 'statd is running' {
  pgrep statd
}
