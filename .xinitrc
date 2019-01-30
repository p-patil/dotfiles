if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Startup scripts
$HOME/scripts/remap_keys.sh
$HOME/scripts/touchscreen.sh --disable
$HOME/scripts/natural_scrolling.sh --enable

exec i3
