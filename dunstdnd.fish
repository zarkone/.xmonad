#!/run/current-system/sw/bin/fish

set is_paused (dunstctl is-paused)
if [ $is_paused = true ]
    echo "<fc=#f0f,#500> - </fc>"
end
