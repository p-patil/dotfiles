if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Settings to configure
/home/piyush/scripts/startup.sh

# Start i3 with dbus (for spotify).
exec dbus-launch i3
