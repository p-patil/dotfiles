if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Start up scripts (placed here because they require X server to be running, and hence using
# systemd won't work)
/home/piyush/scripts/remap_keys
/home/piyush/scripts/natural_scrolling --enable
/home/piyush/scripts/touchscreen --disable

exec i3
# exec i3 && /home/piyush/scripts/i3_scripts/focus-last.py 2> /tmp/start-i3-focus-last-errors_$(head /dev/urandom | tr -dc "a-zA-Z0-9" | head -c 16).txt
