# Path to your oh-my-zsh installation.
export ZSH=~/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="ys"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(z fzf-zsh vi-mode zsh-autosuggestions zsh-completions per-directory-history)

source $ZSH/oh-my-zsh.sh

# z plugin
. "$ZSH/plugins/z/z.sh"

# User configuration

# zsh-autosuggestions key bindings
bindkey '^[[Z' autosuggest-accept # Bind Shift+Tab to accept suggestion

# Virtualenv stuff
export WORKON_HOME="$HOME/.virtualenvs"
for BIN_DIR in "/usr/bin" "/usr/local/bin" "$HOME/.local/bin" "END_OF_LOOP"; do
    if [[ -f "$BIN_DIR/virtualenvwrapper.sh" ]]; then
        source "$BIN_DIR/virtualenvwrapper.sh"
        break
    elif [[ "$BIN_DIR" == "END_OF_LOOP" ]]; then # Didn't find script in any directory
        echo "Couldn't find virtualenvwrapper.sh in /usr/bin, /usr/local/bin, or ~/.local/bin"
    fi
done

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

# Set environment variables
## Reduce lag on pressing <ESC>
export KEYTIMEOUT=0.1

## Set default editor
export EDITOR="/usr/bin/nvim"

## For SSH agent
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval `ssh-agent -s` &> /dev/null
fi
ssh-add ~/.ssh/id_rsa &> /dev/null

## Set PATH
if [[ $PATH != *"/opt/aur_builds/trello"* ]]; then
    export PATH="/opt/aur_builds/trello:$PATH"
fi
if [[ $PATH != *"/opt/firefox"* ]]; then
    export PATH="/opt/firefox:$PATH"
fi
if [[ $PATH != *"/opt/google/chrome"* ]]; then
    export PATH="/opt/google/chrome:$PATH"
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

## Function for printing (or grepping, if passed the search pattern) an ASCII table.
function ascii() {
    CONTROL_CHAR_OUTPUT=$(column -s "," -t < /home/piyush/scripts/ascii_table_ref/control_chars.csv | sed -E "s/(.*)/\t\1/")
    CONTROL_CHAR_HEADER=$(echo "$CONTROL_CHAR_OUTPUT" | sed -n "1 p")
    CONTROL_CHAR_OUTPUT=$(echo "$CONTROL_CHAR_OUTPUT" | sed -n "2,$ p")
    if [[ $# -gt "0" ]]
    then
        if [[ $1 == "-w" ]]
        then
            CONTROL_CHAR_OUTPUT=$(echo "$CONTROL_CHAR_OUTPUT" | grep -w "${@:2}")
        else
            CONTROL_CHAR_OUTPUT=$(echo "$CONTROL_CHAR_OUTPUT" | grep "$@")
        fi
    fi

    PRINTABLE_CHAR_OUTPUT=$(column -s "," -t < /home/piyush/scripts/ascii_table_ref/printable_chars.csv | sed -E "s/(.*)/\t\1/")
    PRINTABLE_CHAR_HEADER=$(echo "$PRINTABLE_CHAR_OUTPUT" | sed -n "1 p")
    PRINTABLE_CHAR_OUTPUT=$(echo "$PRINTABLE_CHAR_OUTPUT" | sed -n "2,$ p")
    if [[ $# -gt "0" ]]
    then
        #PRINTABLE_CHAR_OUTPUT=$(echo "$PRINTABLE_CHAR_OUTPUT" | grep "$@")
        if [[ $1 == "-w" ]]
        then
            PRINTABLE_CHAR_OUTPUT=$(echo "$PRINTABLE_CHAR_OUTPUT" | grep -w "${@:2}")
        else
            PRINTABLE_CHAR_OUTPUT=$(echo "$PRINTABLE_CHAR_OUTPUT" | grep "$@")
        fi
    fi

    EXTENDED_CHAR_OUTPUT=$(column -s "," -t < /home/piyush/scripts/ascii_table_ref/extended_chars.csv | sed -E "s/(.*)/\t\1/")
    EXTENDED_CHAR_HEADER=$(echo "$EXTENDED_CHAR_OUTPUT" | sed -n "1 p")
    EXTENDED_CHAR_OUTPUT=$(echo "$EXTENDED_CHAR_OUTPUT" | sed -n "2,$ p")
    if [[ $# -gt "0" ]]
    then
        if [[ $1 == "-w" ]]
        then
            EXTENDED_CHAR_OUTPUT=$(echo "$EXTENDED_CHAR_OUTPUT" | grep -w "${@:2}")
        else
            EXTENDED_CHAR_OUTPUT=$(echo "$EXTENDED_CHAR_OUTPUT" | grep "$@")
        fi
    fi

    if [[ ! "$CONTROL_CHAR_OUTPUT" =~ "^\s*$" ]]
    then
        echo "Control Characters"
        echo "$CONTROL_CHAR_HEADER"
        echo "$CONTROL_CHAR_OUTPUT"
    fi

    if [[ ! "$PRINTABLE_CHAR_OUTPUT" =~ "^\s*$" ]]
    then
        echo "Printable Characters"
        echo "$PRINTABLE_CHAR_HEADER"
        echo "$PRINTABLE_CHAR_OUTPUT"
    fi

    if [[ ! "$EXTENDED_CHAR_OUTPUT" =~ "^\s*$" ]]
    then
        echo "Extended Characters"
        echo "$EXTENDED_CHAR_HEADER"
        echo "$EXTENDED_CHAR_OUTPUT"
    fi
}

# Quick function for easy arithmetic computation.
function calculator() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: c <EXPR>"
        echo "EXPR is any valid elementary arithmetic expression, extended to include any of the builtin functions in Python's math module."
        echo "Make sure to wrap the argument in single quotes to prevent command line expansion."
        return
    fi

    # Replace ^ with ** so we can pass the expression through python.
    EXPR="$*"
    EXPR=${EXPR//\^/\*\*}

    python -c "from __future__ import division; from math import *; print($EXPR)"
}
alias c="noglob calculator" # Don't expand special characters that collide with mathematical operators, most notably "*".

function cl() {
    cd $1 && ls
}

function cdll() {
    cd $1 && ls -alh
}

alias connect_wifi="/home/piyush/scripts/wifi/wifi_connect"
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias e="/usr/bin/nvim"

function go() {
    if [[ $# -eq 0 ]]
    then
        echo "Usage: go <command>"
        return
    fi

    SPACES_REGEX=" |'"
    COMMAND=""
    for ARG in "$@"
    do
        if [[ "$ARG" =~ "$SPACES_REGEX" ]]
        then
2369,20            ARG=$(printf %q "$ARG")
        fi

        COMMAND="$COMMAND $ARG"
    done

    COMMAND="$COMMAND &> /dev/null &"
    eval "$COMMAND"
}

alias gp="/usr/bin/git pull --all --prune --rebase"

## Function for easy symmetric, password-based decryption of a file with GPG.
function gpg_decrypt() {
    if [[ $# -eq 0 ]]
    then
        echo "Usage: gpg_decrypt <file name>"
        return
    fi

    if [[ "$1" == *".gpg" ]];
    then
        FILE_NAME="${1: : -4}"
    else
        FILE_NAME="$1.decrypted"
    fi

    echo "Attempting to create decrypted file \"$FILE_NAME\""
    gpg --output "$FILE_NAME" --decrypt "$1"

    if [[ $? -eq 0 ]]
    then
        echo "Done"
    else
        echo "Decrypting with GPG failed"
    fi
}

## Function for easy symmetric, password-based encryption of a file with GPG.
function gpg_encrypt() {
    if [[ $# -eq 2 ]]
    then
        echo "Usage: gpg_decrypt <file name>"
        return
    fi

    FILE_NAME="$1.gpg"

    echo "Attempting to create encrypted file \"$FILE_NAME\""
    gpg --output "$FILE_NAME" --symmetric --cipher-algo "AES128" "$1"

    if [[ $? -eq 0 ]]
    then
        echo "Done"
    else
        echo "Encrypting with GPG failed"
    fi
}

function hib() {
    WINDOWS="/dev/nme0n1p3"
    ARCH="/dev/nme0n1p7"
    KALI="dev/nvme0n1p9"

    MOUNTED=$(mount)

    for FS in "$WINDOWS" "$ARCH" "$KALI"; do
        if [[ $MOUNTED == *"$FS"* ]]; then
            sudo umount "$FS"
        fi
    done

    if [[ $(uname -a) == *"Ubuntu"* ]]; then
        sudo pm-hibernate
    else
        sudo systemctl hibernate
    fi
}

## Pretty printed version of "ls -lah".
unalias l # First remove zsh's default alias
function l() {
    if [[ -z "$GNU_COLUMN" ]]; then
        timeout 0.3 column --table &> /dev/null
        if [[ $? -eq 124 ]]; then
            export GNU_COLUMN=true
        else
            export GNU_COLUMN=false
        fi
    fi

    # ls long form column names, in order and comma-separated.
    COL_HEADERS="PERMISSIONS,NUM. LINKS,OWNER,GROUP,SIZE,LAST MODIFIED,NAME"
    if ! $GNU_COLUMN; then
        COL_HEADERS=${COL_HEADERS//,/|}
    fi

    # Delimit the columns with "|", since the column command will try to use whitespace, which is
    # ambiguous, to detect columns.

    ## Regexes to capture the columns
    PERM='[-dlrwxstT]{10}'
    NUM_LINKS='[0-9]+'
    OWNER='[a-z][-a-z0-9]*'
    GROUP='[_a-z][-0-9_a-z]*'
    SIZE='[0-9]+(\.[0-9]+)?[A-Z]?'
    LM='[a-zA-Z]{3}\s+[0-9]{1,2}\s+([0-9]{2}:[0-9]{2}|[0-9]{4})'
    NAME='.*'

    ## Get ls output
    LS_OUTPUT=$(/bin/ls --color -lah "$@")

    ## If the first line is a "total" line, delete it.
    if [[ "$SHELL" == *"/zsh"* ]]; then
        setopt extended_glob
        LS_OUTPUT=${LS_OUTPUT#total [0-9]##[A-Z]#
}
    else
        shopt -s extglob
        LS_OUTPUT=${LS_OUTPUT#total +([0-9])*([A-Z])
}
    fi

    ## Delimit columns with "|"
    LS_OUTPUT=$(sed -E "s/^($PERM)\s+($NUM_LINKS)\s+($OWNER)\s+($GROUP)\s+($SIZE)\s+($LM)\s+($NAME)$/\1|\2|\3|\4|\5|\7|\9/" <<< "$LS_OUTPUT")

    ERROR_CODE=$?
    if [[ $ERROR_CODE -ne 0 ]]; then
        "ERROR: /bin/ls exited with error code $ERROR_CODE"
        return
    fi

    # Use the column command to format as an evenly spaced table with headers.
    if $GNU_COLUMN; then
        column --table --separator "|" --table-columns "$COL_HEADERS" --table-wrap "NAME" <<< "$LS_OUTPUT"
    else
        LS_OUTPUT="$COL_HEADERS
$LS_OUTPUT"
        column -t -s "|" <<< "$LS_OUTPUT"
    fi
}

## Function to create and then automatically change into a directory.
function mkcd() {
    mkdir "$1"
    cd "$1"
}

alias mount_sdb1="/home/piyush/scripts/mount/mount_sdb1"
alias mount_sdc1="/home/piyush/scripts/mount/mount_sdc1"

function music() {
    OLD_DIR=$PWD

    cd /home/piyush/projects/Music-Player-Basic
    workon Music-Player-Basic
    python main.py

    deactivate
    cd "$OLD_DIR"
}

function move_workspace() {
    i3 workspace "$1" && i3 move workspace to output "$2"
}

alias off_mon="/home/piyush/scripts/monitor/off.py"
alias on_mon="/home/piyush/scripts/monitor/on.py"
alias on_tv="xrandr --output eDP1 --primary --auto --output HDMI2 --right-of eDP1 --mode 1920x1080"
alias off_tv="xrandr --output eDP1 --primary --auto --output HDMI2 --off"

function open_pdfs() {
    # Allow caller to pass a file with PDFs to open.
    if [[ $# -gt 0 ]]
    then
        CACHE_FILE=$1
    else
        CACHE_FILE="~/.cache/piyush_evince_cache.txt"
    fi

    # Expand home directory if it exists (this is a bit hacky).
    HOME_ESCAPED=$(echo "$HOME" | sed "s|/|\\\/|g")
    CACHE_FILE=$(echo "$CACHE_FILE" | sed -E "s/\~/$HOME_ESCAPED/")

    # Verify that cache file exists.
    if [[ ! -f "$CACHE_FILE" ]]
    then
        echo "ERROR: Cache file \"$CACHE_FILE\" isn't a regular file or doesn't exist"
        return
    fi

    # Iterate over the lines of the cache file, opening PDFs with evince in the background.
    while read -r FILE; read -r PAGE_NUM_AND_WORKSPACE
    do
        # Parse page number to open to and workspace to put PDF in
        PAGE_NUM=$(echo "$PAGE_NUM_AND_WORKSPACE" | cut -d "," -f 1)
        WORKSPACE=$(echo "$PAGE_NUM_AND_WORKSPACE" | cut -d "," -f 2)

        (i3 workspace "$WORKSPACE" && evince --page-index="$PAGE_NUM" "$FILE") &> /dev/null &
        sleep 0.5 # Wait a bit for the workspace to change before proceeding
    done < "$CACHE_FILE"
}

# Mount partition by its partition label.
function plmount() {
    if [[ $# -eq 1 ]]; then
        PARTLABEL=$1
        MOUNT_POINT="/mnt/$PARTLABEL"
        echo "Using default mount point $MOUNT_POINT"
    elif [[ $# -eq 2 ]]; then
        PARTLABEL=$1
        MOUNT_POINT=$2
    else
        echo "Usage: plmount <PARTLABEL> [<MOUNT POINT>]"
        return
    fi

    OUTPUT=$(lsblk -o NAME,PARTLABEL | grep -iE "^.*\s+arch$")
    if [[ -z $OUTPUT ]]; then
        echo "No matches found for partlabel $PARTLABEL"
        return
    elif [[ $(echo "$OUTPUT" | wc -l) -gt 1 ]]; then
        echo "Multiple matches:"
        echo "$OUTPUT"
        return
    fi

    NAME=$(echo "$OUTPUT" | cut -d " " -f 1 | strings)
    sudo mount "/dev/$NAME" "$MOUNT_POINT"
}

alias push_dotfiles="/home/piyush/scripts/push_dotfiles.sh"
alias quick_man="/home/piyush/scripts/quick_man.py"
alias remap_keys="/home/piyush/scripts/remap_keys.sh"
alias reset_mouse="/home/piyush/scripts/mouse/switch.sh --right"
alias restart="/home/piyush/scripts/restart.py"
alias restore="/home/piyush/projects/Session-Storer/restore"
alias save="/home/piyush/projects/Session-Storer/save"

function say() {
    if [[ $# -eq 0 ]]
    then
        echo "Usage: say \"<words>\""
        return
    fi

    espeak "\"$@\"" &> /dev/null
}

function scrambler() {
    OLD_DIR=$PWD

    cd /home/piyush/projects/scripts/scrambler.py
    workon scrambler
    ./scrambler "$@"

    deactivate
    cd "$OLD_DIR"
}

alias screenshot="import /tmp/screenshot.png && xclip -selection \"clipboard\" -target \"image/png\" -i < /tmp/screenshot.png"
alias switch_mouse="/home/piyush/scripts/mouse/switch.sh --left"
alias sz="source $HOME/.zshrc"
alias ts_enable="/home/piyush/scripts/touchscreen.sh --enable"
alias ts_disable="/home/piyush/scripts/touchscreen.sh --disable"
alias umount_sdb1="/home/piyush/scripts/mount/umount_sdb1"
alias umount_sdc1="/home/piyush/scripts/mount/umount_sdc1"

function volume() {
    if [[ $# -eq 0 ]] || [[ ! $1 =~ "^[0-9]+$" ]]
    then
        echo "Usage: volume <PERCENTAGE>"
        return
    elif [[ $1 -gt 100 ]]
    then
        echo "WARNING: Setting volume to above 100%"
    fi

    pactl set-sink-volume 0 "$1%" > /dev/null
}

alias vlc="vlc --play-and-exit"
alias wat="/opt/wat"
alias wr="sudo systemctl restart netctl-auto@wlp4s0.service"
alias xclip="/usr/bin/xclip -selection \"clipboard\"" # Copy to system clipboard by default

# Add vim bindings
if [[ $TERM != "xterm-termite" ]]
then
    bindkey -v
fi

# fzf stuff
export FZF_DEFAULT_COMMAND="ag --hidden --ignore .git -f -g"

# bd
. $HOME/.zsh/plugins/bd/bd.zsh

# NOTE: Additional installs, not found here, correspond to .zsh scripts in ~/.oh-my-zsh/custom

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Ubuntu specific stuff
if [[ $(uname -a) == *"Ubuntu"* ]]; then
    alias nuro_vpn="nmcli con up id \"Nuro VPN\" --ask"
    alias nuro_vpn_down="nmcli con down id \"Nuro VPN\""

    alias on_tv="xrandr --output eDP-1 --primary --auto --output HDMI-2 --right-of eDP-1 --mode 1920x1080"
    alias off_tv="xrandr --output eDP-1 --primary --auto --output HDMI-2 --off"

    export ARCH="/mnt/arch/home/piyush"
fi
