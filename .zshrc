# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=/home/piyush/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="ys"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
 ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(z vi-mode history-search-multi-word)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

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

# Reduce lag on pressing <ES>
export KEYTIMEOUT=0.1

# Set default editor
export EDITOR="/usr/bin/nvim"

# Set default terminal to open in i3
export TERMINAL="/usr/bin/xterm"

export PATH=$PATH:/opt/google/chrome
export PATH=$PATH:/opt/sublime_text_3
export PATH=$PATH:/opt/slack-desktop/pkg/slack-desktop/usr/bin
export PATH=$PATH:/opt/Trello
export PATH=$PATH:/opt/firefox
export PATH=$PATH:/opt/tor-browser_en-US

# Local-specific stuff
alias e="/usr/bin/nvim"
alias vim="/usr/bin/nvim"
alias xclip="/usr/bin/xclip -selection \"clipboard\"" # Copy to system clipboard by default
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"
alias screenshot="import /tmp/screenshot.png && xclip -selection \"clipboard\" -target \"image/png\" -i < /tmp/screenshot.png"

alias ascii="/home/piyush/scripts/ascii_table_ref/print_ascii_table"
alias go="/home/piyush/scripts/go"
alias music="/home/piyush/projects/Music-Player-Basic/main.py"
alias wifi_restart="/home/piyush/scripts/wifi_restart"
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
sudo="/home/piyush/scripts/sudo_open" # Don't alias since it'll conflict with existing sudo
alias switch_mouse="/home/piyush/scripts/mouse/switch"
alias tor="/opt/tor-browser_en-US/start-tor-browser.desktop"
