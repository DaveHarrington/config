#!/bin/bash

ping_good=`ping -c2 -W1 'dev240.prn1.facebook.com' 2> /dev/null | grep -E '[1|2] packets received' -c`
sshfs_mount=`df -H | grep -c '/Volumes/sshfs/phab'`

if [[ $ping_good > 0  && $sshfs_mount == 0 ]]; then
    sshfs phab:/ /Volumes/sshfs/phab/ -o cache_timeout=300 -o cache_stat_timeout=900 -o cache_dir_timeout=900 -o cache_link_timeout=900 -o follow_symlinks
fi

