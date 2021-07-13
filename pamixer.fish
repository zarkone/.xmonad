#!/run/current-system/sw/bin/fish

function echo_pamixer
    set res (pamixer --get-volume-human)
    if [ $res = muted ]
        echo "<fc=#f00><icon=/home/zarkone/.xmonad/xbm/volume-mute.xbm/> ... </fc>"
    else
        echo "<fc=#f0f><icon=/home/zarkone/.xmonad/xbm/volume.xbm/> $res </fc>"
    end
end

echo_pamixer
