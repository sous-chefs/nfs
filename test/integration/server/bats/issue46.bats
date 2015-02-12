#!/usr/bin/env bats

@test 'ISSUE #46: uniform anonuid/anongid on unrelated shares' {
  result=`egrep -c '/tmp/share[0-9] 127.0.0.1\(ro,sync,root_squash,anonuid=[0-9]+,anongid=[0-9]+\)' /etc/exports`
  [ $result -eq 3 ]
}

@test 'ISSUE #46: unrelated shares are not stairstepping anounuid/anongid' {
  egrep -v '/tmp/share[0-9] 127.0.0.1\(rw,sync,root_squash,(anonuid=[0-9]+,anongid=[0-9]+){2,}\)' /etc/exports
}
