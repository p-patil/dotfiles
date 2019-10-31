if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Configure settings

## Remap caps lock to escape
xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "keycode 66 = Escape"

## Disable touchscreen
xinput disable "ELAN Touchscreen"

## Touchpad settings
xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Natural Scrolling Enabled" 1 # Natural scrolling
xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Accel Speed" 0.75            # Pointer acceleration
xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1           # Tap to click

exec i3
