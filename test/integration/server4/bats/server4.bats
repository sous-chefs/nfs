#!/usr/bin/env bats
load ../../server/bats/server.bats

@test 'idmapd is running' {
  pgrep idmap
}
