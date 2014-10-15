#!/usr/bin/env bats

@test 'portmap appears to be listening on TCP 111' {
  netstat -ltn|grep :111
}

@test 'portmap appears to be listening on UDP 111' {
  netstat -lun|grep :111
}

@test 'statd appears to be listening on TCP 32765' {
  netstat -ltn|grep :32765
}

@test 'mountd appears to be listening on TCP 32767' {
  netstat -ltn|grep :32767
}

@test 'mountd appears to be listening on UDP 32767' {
  netstat -lun|grep :32767
}

@test 'lockd appears to be listening on TCP 32768' {
  if [ -f /etc/redhat-release ]; then
    netstat -ltn|grep :32768
  else
    skip "Skipping TCP listening test for lockd"
  fi
}

@test 'lockd appears to be listening on UDP 32768' {
  if [ -f /etc/redhat-release ]; then
    netstat -lun|grep :32768
  else
    skip "Skipping UDP listening test for lockd"
  fi
}

@test 'portmap or rpcbind is running' {
  pgrep rpcbind||pgrep portmap
}

@test 'statd is running' {
  pgrep statd
}

@test 'lockd is running' {
  pgrep lockd
}

@test 'mountd is running' {
  pgrep mountd
}
