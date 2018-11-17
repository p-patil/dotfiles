$HOME/scripts/remap_keys.sh
$HOME/scripts/touchscreen.sh --disable
$HOME/scripts/natural_scrolling.sh --enable

if [[ ! $DISPLAY && XDG_VTNR -eq 1 ]]
then
    exec startx
fi
