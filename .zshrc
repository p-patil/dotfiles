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
plugins=(z vi-mode zsh-autosuggestions zsh-completions per-directory-history)

source $ZSH/oh-my-zsh.sh

# User configuration

# zsh-autosuggestions key bindings
bindkey '^[[Z' autosuggest-accept # Bind Shift+Tab to accept suggestion

# Virtualenv stuff
export WORKON_HOME=~/.virtualenvs
source /usr/bin/virtualenvwrapper.sh

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
if [[ $PATH != *"/opt/sublime_text"* ]]; then
    export PATH=$PATH:/opt/sublime_text_3
fi
if [[ $PATH != *"/opt/slack-desktop/pkg/slack-desktop/usr/bin"* ]]; then
    export PATH=$PATH:/opt/slack-desktop/pkg/slack-desktop/usr/bin
fi
if [[ $PATH != *"/opt/Trello"* ]]; then
    export PATH=$PATH:/opt/Trello
fi
if [[ $PATH != *"/opt/firefox"* ]]; then
    export PATH=$PATH:/opt/firefox
fi
if [[ $PATH != *"/opt/tor-browser_en-US"* ]]; then
    export PATH=$PATH:/opt/tor-browser_en-US
fi
if [[ $PATH != *"/opt/google/chrome"* ]]; then
    export PATH=$PATH:/opt/google/chrome
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias ascii="/home/piyush/scripts/ascii_table_ref/print_ascii_table"
function cdl() {
    cd $1 && ls
}
function cdll() {
    cd $1 && ls -alh
}
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias e="/usr/bin/nvim"
alias go="/home/piyush/scripts/go"
# Function for easy symmetric, password-based decryption of a file with GPG.
function gpg_decrypt() {
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
# Function for easy symmetric, password-based encryption of a file with GPG.
function gpg_encrypt() {
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
# Function to create and then automatically change into a directory.
function mkcd() {
    mkdir "$1"
    cd "$1"
}
# Function to automatically install the set packages after creating any virtualenv. NOTE: the
# original mkvirtualenv function in /usr/bin/virtualenvwrapper.sh has been renamed.
function mkvirtualenv() {
    mkvirtualenv_original -i neovim $@
}
alias mount_sdb1="/home/piyush/scripts/mount/mount_sdb1"
alias mount_sdc1="/home/piyush/scripts/mount/mount_sdc1"
alias umount_sdb1="/home/piyush/scripts/mount/umount_sdb1"
alias umount_sdc1="/home/piyush/scripts/mount/umount_sdc1"
function music() {
    OLD_DIR=$PWD

    cd /home/piyush/projects/Music-Player-Basic
    workon Music-Player-Basic
    python main.py

    deactivate
    cd "$OLD_DIR"
}
alias off_mon="/home/piyush/scripts/monitor/off"
alias on_mon="/home/piyush/scripts/monitor/on"
alias push_dotfiles="/home/piyush/scripts/push_dotfiles"
alias quick_man="/home/piyush/scripts/quick_man/quick_man"
alias remap_keys="/home/piyush/scripts/remap_keys"
alias reset_mouse="/home/piyush/scripts/mouse/reset"
alias restart="/home/piyush/scripts/restart"
alias restore="/home/piyush/projects/Session-Storer/restore"
alias save="/home/piyush/projects/Session-Storer/save"
function scrambler() {
    OLD_DIR=$PWD

    cd /home/piyush/projects/scripts/scrambler
    workon scrambler
    ./scrambler "$@"

    deactivate
    cd "$OLD_DIR"
}
alias screenshot="import /tmp/screenshot.png && xclip -selection \"clipboard\" -target \"image/png\" -i < /tmp/screenshot.png"
alias switch_mouse="/home/piyush/scripts/mouse/switch"
alias tor="(cd /opt/tor-browser_en-US && /opt/tor-browser_en-US/start-tor-browser.desktop)"
alias ts_enable="xinput enable $(sed -nE "s/.*Touchscreen\s+id=([0-9]+).*/\1/p" <(xinput))"
alias ts_disable="xinput disable $(sed -nE "s/.*Touchscreen\s+id=([0-9]+).*/\1/p" <(xinput))"
alias trello="/opt/Trello/Trello"
alias vlc="vlc --play-and-exit"
alias wifi_connect="/home/piyush/scripts/wifi/wifi_connect"
alias wifi_restart="/home/piyush/scripts/wifi/wifi_restart"
sudo="/home/piyush/scripts/sudo_open" # Don't alias since it'll conflict with existing sudo
alias xclip="/usr/bin/xclip -selection \"clipboard\"" # Copy to system clipboard by default

# Add vim bindings
bindkey -v

# fzf stuff
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="ag --hidden --ignore .git -f -g"

# bd
. $HOME/.zsh/plugins/bd/bd.zsh

# NOTE: Additional installs, not found here, correspond to .zsh scripts in ~/.oh-my-zsh/custom
