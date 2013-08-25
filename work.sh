#!/bin/bash

ping_good=`ping -c2 -W1 'dev240.prn1.facebook.com' 2> /dev/null | grep -E '[1|2] packets received' -c`
sshfs_mount=`df -H | grep -c '/Volumes/sshfs/dev'`

if [[ $ping_good == 0 ]]; then
  echo 'Could not reach dev server - check connection / vpn'
  exit 1;
fi

if [[ $sshfs_mount == 0 ]]; then
  echo 'Mounting sshfs'
  sshfs dev:/ /Volumes/sshfs/dev/ -o cache_timeout=300 \
    -o cache_stat_timeout=900 -o cache_dir_timeout=900 \
    -o cache_link_timeout=900 -o follow_symlinks
fi

# main() loop
while true; do
  echo 'syncing'
  csync ~/projects/fbcode/perflab/ /Volumes/sshfs/dev/data/users/drh/fbcode/perflab/
  sleep 5
done
