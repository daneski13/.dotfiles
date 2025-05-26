# Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Go Path
export PATH=$PATH:$(go env GOPATH)/bin

# .local custom scripts
if [[ ":$PATH:" != *":$HOME/.local/scripts:"* ]]; then
    export PATH="$HOME/.local/scripts:$PATH"
fi
# .local bin
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi
# Spicetify
export SPICETIFY_INSTALL="$HOME/spicetify-cli"
if [[ ":$PATH:" != *":$SPICETIFY_INSTALL:"* ]]; then
    export PATH="$SPICETIFY_INSTALL:$PATH"
fi

# 64 bit intel/amd and arm always
export ARCHFLAGS="-arch x86_64 -arch arm64"

# Projects folder
export PROJECTS=~/Desktop/Projects
# flavours directories
export FLAVOURS_CONFIG_FILE=~/.config/flavours/config.toml
export FLAVOURS_DATA_DIRECTORY=~/.config/flavours/

# Load completion system
autoload -U compinit; compinit

# Update oh-my-zsh
zstyle ':omz:update' mode reminder
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# ZSH theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Oh my ZSH
source "$ZSH/oh-my-zsh.sh"

# Plugins
# If on macOS, use homebrew zplug
if [[ "$OSTYPE" == "darwin"* ]]; then
    export ZPLUG_HOME=/opt/homebrew/opt/zplug
else
    export ZPLUG_HOME=~/.zplug
fi
source "$ZPLUG_HOME/init.zsh"

zplug "plugins/autojump", from:oh-my-zsh
zplug "plugins/gh", from:oh-my-zsh
zplug "plugins/dotenv", from:oh-my-zsh
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/web-search", from:oh-my-zsh
zplug "plugins/copypath", from:oh-my-zsh
zplug "plugins/copyfile", from:oh-my-zsh
zplug "plugins/jsontools", from:oh-my-zsh
if [[ "$OSTYPE" == "darwin"* ]]; then
    zplug "plugins/macos", from:oh-my-zsh
fi

zplug "MichaelAquilina/zsh-you-should-use"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load


# The Fuck
eval "$(thefuck --alias)"

# alias to better programs
alias vim='nvim'
alias ls='eza -a --icons --group-directories-first'
alias cat='bat'
# silence you-should-use
export YSU_IGNORED_ALIASES=("vim" "npm" "ls" "cat")

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"
# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/dane/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/dane/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/dane/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/dane/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# pnpm
export PNPM_HOME="${HOME}/.local/share/pnpm"
case ":$PATH:" in
    *":$PNPM_HOME:"*) ;;
    *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "/Users/dane/.bun/_bun" ] && source "/Users/dane/.bun/_bun"


[[ -f "$HOME/fig-export/dotfiles/dotfile.zsh" ]] && builtin source "$HOME/fig-export/dotfiles/dotfile.zsh"

# Q post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
