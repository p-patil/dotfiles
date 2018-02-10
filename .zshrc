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
plugins=(z vi-mode fzf-zsh)

source $ZSH/oh-my-zsh.sh

# User configuration

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
if [[ $PATH != *"/opt/chromium-vaapi"* ]]; then
    export PATH=$PATH:/opt/chromium-vaapi
fi

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias ascii="/home/piyush/scripts/ascii_table_ref/print_ascii_table"
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias e="/usr/bin/nvim"
alias go="/home/piyush/scripts/go"
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
function mkcd() {
    mkdir "$1"
    cd "$1"
}
alias music="/home/piyush/projects/Music-Player-Basic/main.py"
alias off_mon="/home/piyush/scripts/monitor/off"
alias on_mon="/home/piyush/scripts/monitor/on"
alias push_dotfiles="/home/piyush/scripts/push_dotfiles"
alias quick_man="/home/piyush/scripts/quick_man/quick_man"
alias remap_keys="/home/piyush/scripts/remap_keys"
alias reset_mouse="/home/piyush/scripts/mouse/reset"
alias restart="/home/piyush/scripts/restart"
alias restore="/home/piyush/projects/Session-Storer/restore"
alias save="/home/piyush/projects/Session-Storer/save"
alias scrambler="/home/piyush/scripts/scrambler/scrambler"
alias screenshot="import /tmp/screenshot.png && xclip -selection \"clipboard\" -target \"image/png\" -i < /tmp/screenshot.png"
alias switch_mouse="/home/piyush/scripts/mouse/switch"
alias tor="(cd /opt/tor-browser_en-US && /opt/tor-browser_en-US/start-tor-browser.desktop)"
alias trello="/opt/Trello/Trello"
alias vlc="vlc --play-and-exit"
alias wifi_connect="/home/piyush/scripts/wifi/wifi_connect"
alias wifi_restart="/home/piyush/scripts/wifi/wifi_restart"
sudo="/home/piyush/scripts/sudo_open" # Don't alias since it'll conflict with existing sudo
alias xclip="/usr/bin/xclip -selection \"clipboard\"" # Copy to system clipboard by default

# Add vim bindings
bindkey -v

# Display vim mode
function zle-line-init zle-keymap-select {
    RPS1="${${KEYMAP/vicmd/-- NORMAL --}/(main|viins)/-- INSERT --}"
    RPS2=$RPS1
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
