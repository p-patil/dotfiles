$HOME/scripts/remap_keys.sh
$HOME/scripts/touchscreen.sh --disable

if [[ ! $DISPLAY && XDG_VTNR -eq 1 ]]
then
    exec startx
fi
