if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Start up scripts (placed here because they require X server to be running, and hence using
# systemd won't work)
/home/piyush/scripts/remap_keys.sh
/home/piyush/scripts/natural_scrolling.sh --enable
/home/piyush/scripts/touchscreen.sh --disable

# udisks2 front-end for automounting
udiskie &

exec i3
