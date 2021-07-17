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

## For SSH agent
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval `ssh-agent -s` &> /dev/null
fi
ssh-add ~/.ssh/id_rsa &> /dev/null

## Add packages built from source to PATH
for OPTPATH in /opt/{aur_builds/trello,firefox,google/chrome,google-cloud-sdk/bin,$HOME/.local/bin}; do
    if [[ $PATH != *"$OPTPATH"* ]]; then
        export PATH="$OPTPATH:$PATH"
    fi
done

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
source .zsh_aliases

# Add vim bindings
if [[ $TERM != "xterm-termite" ]]
then
    bindkey -v
fi

# fzf stuff
export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# NOTE: Additional installs, not found here, correspond to .zsh scripts in ~/.oh-my-zsh/custom

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
