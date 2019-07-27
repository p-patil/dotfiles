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
if [[ $PATH != *"$HOME/.local/bin"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

## Function for printing (or grepping, if passed the search pattern) an ASCII table.
function ascii() {
    CONTROL_CHAR_OUTPUT=$(column -s "," -t < $HOME/scripts/ascii_table_ref/control_chars.csv | sed -E "s/(.*)/\t\1/")
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

    PRINTABLE_CHAR_OUTPUT=$(column -s "," -t < $HOME/scripts/ascii_table_ref/printable_chars.csv | sed -E "s/(.*)/\t\1/")
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

    EXTENDED_CHAR_OUTPUT=$(column -s "," -t < $HOME/scripts/ascii_table_ref/extended_chars.csv | sed -E "s/(.*)/\t\1/")
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

# Alias to list large files in current directory.
function big() {
    SEARCH_PATH="."
    NUM=10
    while [[ "${1:-}" != "" ]]; do
        case "$1" in
            "-n")
                shift
                NUM=$1
            ;;
            *)
                SEARCH_PATH=$1
            ;;
        esac
        shift
    done

    if [[ ! -d "$SEARCH_PATH" ]]; then
        echo "Directory does not exist"
        return
    fi

    du -sh $SEARCH_PATH/* | sort -hr | head -n "$NUM"
}

# Quick function for easy arithmetic computation.
function calculator() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: $funcstack[1] <EXPR>"
        echo "EXPR is any valid elementary arithmetic expression, extended to include any of the builtin functions in Python's math module."
        echo "Make sure to wrap the argument in single quotes to prevent command line expansion."
        return
    fi

    # Replace ^ with ** so we can pass the expression through python.
    EXPR="$*"
    EXPR=${EXPR//\^/\*\*}

    python3 -c "from __future__ import division; from math import *; print($EXPR)"
}
alias c="noglob calculator" # Don't expand special characters that collide with mathematical operators, most notably "*".

function cl() {
    cd $1 && ls
}

function cdll() {
    cd $1 && ls -alh
}

alias connect_wifi="$HOME/scripts/wifi/wifi_connect"

# Convenience function to get shell color codes.
function color() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: $funcstack[1] [--foreground | --background] <color name>"
        echo "Run this script in command substitution when printing something, and anything else printed in the same echo command will have the given color."
        return
    elif [[ $# -eq 1 ]]; then
        NAME=${1:-}
        NAME="$NAME:l"
        TYPE="foreground"
    elif [[ $# -eq 2 ]]; then
        NAME="$2"
        if [[ "$1" == "--foreground" ]]; then
            TYPE="foreground"
        elif [[ "$1" == "--background" ]]; then
            TYPE="background"
        elif [[ ! "$1" =~ "--"* ]] && [[ ! "$2" =~ "--"* ]]; then
            TYPE="foreground"
            NAME="$1 $2"
        else
            echo "Usage: $funcstack[1] [--foreground | --background] <color name>"
            return
        fi
    else
        echo "Usage: $funcstack[1] [--foreground | --background] <color name>"
        return
    fi

    if [[ "$TYPE" == "foreground" ]]; then
        case "$NAME" in
            "black") CODE="30" ;;
            "red") CODE="31" ;;
            "green") CODE="32" ;;
            "yellow") CODE="33" ;;
            "blue") CODE="34" ;;
            "magenta") CODE="35" ;;
            "cyan") CODE="36" ;;
            "light grey") CODE="37" ;;
            "dark grey") CODE="90" ;;
            "light red") CODE="91" ;;
	        "light green") CODE="92" ;;
            "light yellow") CODE="93" ;;
            "light blue") CODE="94" ;;
            "light magenta") CODE="95" ;;
            "light cyan") CODE="96" ;;
            "white") CODE="97" ;;
            *) CODE=""
        esac
    else # Background
        case "$NAME" in
            "black") CODE=40 ;;
            "red") CODE=41 ;;
            "green") CODE=42 ;;
            "yellow") CODE=43 ;;
            "blue") CODE=44 ;;
            "magenta") CODE=45 ;;
            "cyan") CODE=46 ;;
            "light gray") CODE=47 ;;
            "dark gray") CODE=100 ;;
            "light red") CODE=101 ;;
            "light green") CODE=102 ;;
            "light yellow") CODE=103 ;;
            "light blue") CODE=104 ;;
            "light magenta") CODE=105 ;;
            "light cyan") CODE=106 ;;
            "white code")=107 ;;
            *) CODE=""
        esac
    fi

    if [[ -z "$CODE" ]]; then
        echo "Invalid color \"$NAME\""
        return
    fi

    echo -e '\e[0;'$CODE"m"
}

alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias e="/usr/bin/nvim"

# Git aliases
alias ga="git add"
alias gap="git add --patch"
alias gc="git commit"
alias gca="git commit --amend --no-edit"
alias gd="git diff"
alias gl="git ls-files"
alias glf="git ls-files -m -d"
alias glg="git log"
alias glgs="git log --stat"
alias gp="git pull --all --prune --rebase"
alias gS="nocorrect git status" # Stop zsh from trying to correct git status to stats
alias gsh="git stash --include-untracked"
alias gshl="git stash list"
alias gshlp="git stash list --patch"
alias gshls="git stash list --stat"
alias gshp="git stash pop"
## Aliases for operating on the "next" unstaged file
alias glfn="git ls-files -m -d | head -n 1" # Show the next file
alias gra="git rebase --abort"
alias grc="git rebase --continue"
alias gri="git rebase --interactive"
### Add next file
function gan() {
  NUM=1
  PATCH=""

  # Parse arguments.
  if [[ $# -gt 2 ]]; then
      echo "Usage: $funcstack[1] [-p] [n]"
    return
  elif [[ $# -eq 1 ]]; then
    if [[ "$1" == "-p" || "$1" == "--patch" ]]; then
      PATCH="$1"
    else
      NUM="$1"
    fi
  elif [[ $# -eq 2 ]]; then
    PATCH="$1"
    NUM="$2"
  fi

  # Validate arguments.
  if [[ ! "$NUM" =~ [0-9]+ ]]; then
    echo "Argument must be a positive integer"
    return
  elif [[ -n "$PATCH" && "$PATCH" != "-p" && "$PATCH" != "--patch" ]]; then
    echo "Usage: $funcstack[1] [-p] [n]"
    return
  fi

  INDEX_FILES=$(git ls-files -m -d)
  NUM_FILES=$(echo "$INDEX_FILES" | wc -l)
  if [[ $NUM -gt $NUM_FILES ]]; then
    echo "Out of bounds argument, only $NUM_FILES files in index"
    return
  fi

  if [[ -n "$PATCH" ]]; then
    git add -p $(echo "$INDEX_FILES" | sed -n "$NUM p")
  else
    git add $(echo "$INDEX_FILES" | sed -n "$NUM p")
  fi
}
### Edit next file
function gen() {
  if [[ $# -ge 2 ]]; then
    echo "Usage: $funcstack[1] [n]"
    return
  elif [[ $# -eq 1 && ! "$1" =~ [0-9]+ ]]; then
    echo "Argument must be a positive integer"
    return
  fi

  INDEX_FILES=$(git ls-files -m -d)
  NUM_FILES=$(echo "$INDEX_FILES" | wc -l)
  if [[ $1 -gt $NUM_FILES ]]; then
    echo "Out of bounds argument, only $NUM_FILES files in index"
    return
  fi

  nvim $(echo "$INDEX_FILES" | sed -n "${1:=1} p")
}
### Show diff next file
function gdn() {
  if [[ $# -ge 2 ]]; then
    echo "Usage: $funcstack[1] [n]"
    return
  elif [[ $# -eq 1 && ! "$1" =~ [0-9]+ ]]; then
    echo "Argument must be a positive integer"
    return
  fi

  INDEX_FILES=$(git ls-files -m -d)
  NUM_FILES=$(echo "$INDEX_FILES" | wc -l)
  if [[ $1 -gt $NUM_FILES ]]; then
    echo "Out of bounds argument, only $NUM_FILES files in index"
    return
  fi

  git diff $(echo "$INDEX_FILES" | sed -n "${1:=1} p")
}

## Function for easy symmetric, password-based decryption of a file with GPG.
function gpg_decrypt() {
    if [[ $# -eq 0 ]]
    then
        echo "Usage: $funcstack[1] <file name>"
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
        echo "Usage: $funcstack[1] <file name>"
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

    NAME=$(uname -a)
    if [[ $NAME == *"Ubuntu"* ]]; then
        sudo pm-hibernate
    elif [[ $NAME == *"arch-64"* ]]; then
        sudo systemctl hibernate
    else
        echo "Unknown OS"
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
    if [[ "$LS_OUTPUT" =~ "total [0-9]+(\.[0-9]+)?[A-Z]"* ]]; then
        LS_OUTPUT=$(echo "$LS_OUTPUT" | sed "1d")
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

alias mount_sdb1="$HOME/scripts/mount/mount_sdb1"
alias mount_sdc1="$HOME/scripts/mount/mount_sdc1"

function music() {
    OLD_DIR=$PWD

    cd $HOME/projects/Music-Player-Basic
    lsvirtualenv -b | grep "music-player"
    if [[ $? -ne 0 ]]; then
        echo "Virtualenv not found"
        return
    fi
    workon music-player
    python main.py

    deactivate
    cd "$OLD_DIR"
}

function move_workspace() {
    i3 workspace "$1" && i3 move workspace to output "$2"
}

alias off_mon="$HOME/scripts/monitor/off.py"
alias on_mon="$HOME/scripts/monitor/on.py"
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
        echo "Usage: $funcstack[1] <PARTLABEL> [<MOUNT POINT>]"
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

function program() {
    USAGE="program <LANGUAGE>\nSupported languages: C, C++, Java, Python"
    if [[ $# -ne 1 ]]; then
        echo "$USAGE"
        return
    fi

    LANG=$1:l
    case $LANG in
        c )
            cat $HOME/scripts/base\ language\ programs/c | nvim -c "set filetype=c" -
            ;;
        c | cpp )
            cat $HOME/scripts/base\ language\ programs/cpp | nvim -c "set filetype=cpp" -
            ;;
        java )
            cat $HOME/scripts/base\ language\ programs/java | nvim -c "set filetype=java" -
            ;;
        python )
            cat $HOME/scripts/base\ language\ programs/python | nvim -c "set filetype=python" -
            ;;
        * )
            echo "Unsupported language"
            return
    esac
}
alias p="nocorrect program"

alias push_dotfiles="$HOME/scripts/push_dotfiles.sh"
alias quick_man="$HOME/scripts/quick_man.py"
alias remap_keys="$HOME/scripts/remap_keys.sh"
alias reset_mouse="$HOME/scripts/mouse/switch.sh --right"
alias restart="$HOME/scripts/restart.py"
alias restore="$HOME/projects/Session-Storer/restore"
alias save="$HOME/projects/Session-Storer/save"

function say() {
    if [[ $# -eq 0 ]]
    then
        echo "Usage: $funcstack[1] \"<words>\""
        return
    fi

    espeak "\"$@\"" &> /dev/null
}

alias s="start"
function start() {
    if [[ $# -eq 0 ]]
    then
        echo "Usage: $funcstack[1] <command>"
        return
    fi

    SPACES_REGEX=" |'"
    COMMAND=""
    for ARG in "$@"
    do
        if [[ "$ARG" =~ "$SPACES_REGEX" ]]
        then
            ARG=$(printf %q "$ARG")
        fi

        COMMAND="$COMMAND $ARG"
    done

    COMMAND="$COMMAND &> /dev/null &"
    eval "$COMMAND"
}

function scrambler() {
    OLD_DIR=$PWD

    cd $HOME/projects/scripts/scrambler.py
    workon scrambler
    ./scrambler "$@"

    deactivate
    cd "$OLD_DIR"
}

alias screenshot="import /tmp/screenshot.png && xclip -selection \"clipboard\" -target \"image/png\" -i < /tmp/screenshot.png"
alias switch_mouse="$HOME/scripts/mouse/switch.sh --left"
alias sz="source $HOME/.zshrc"
alias ts_enable="$HOME/scripts/touchscreen.sh --enable"
alias ts_disable="$HOME/scripts/touchscreen.sh --disable"
alias umount_sdb1="$HOME/scripts/mount/umount_sdb1"
alias umount_sdc1="$HOME/scripts/mount/umount_sdc1"

function volume() {
    if [[ $# -eq 0 ]] || [[ ! $1 =~ "^[0-9]+$" ]]
    then
        echo "Usage: $funcstack[1] <PERCENTAGE>"
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
fi
