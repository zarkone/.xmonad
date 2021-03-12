#!/run/current-system/sw/bin/fish

set avail (zfs list zroot/root/$argv | tail -n -1 | awk '{print $2}')
echo "/$argv: $avail"
