#!/bin/zsh

# amazon q pre block. keep at the top of this file
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

# powerlevel10k instant prompt (keep at the top for speed)
[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

#############################################################################
# HELPER FUNCTIONS
#############################################################################

# path_prepend: prepend a directory to the PATH environment variable if it exists
path_prepend() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$1:$PATH"
  fi
}

# path_append: append a directory to the PATH environment variable if it exists
path_append() {
  if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
    export PATH="$PATH:$1"
  fi
}

# lazy loading function for NVM
nvm_load() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$BREW_DIR/opt/nvm/nvm.sh" ] && source "$BREW_DIR/opt/nvm/nvm.sh"
  [ -s "$BREW_DIR/opt/nvm/etc/bash_completion.d/nvm" ] && source "$BREW_DIR/opt/nvm/etc/bash_completion.d/nvm"
}

#############################################################################
# CORE ENVIRONMENT VARIABLES & PATH SETTINGS
#############################################################################

# common flags
[[ -z "$LDFLAGS" ]] && export LDFLAGS=""
[[ -z "$CPPFLAGS" ]] && export CPPFLAGS=""

# brew (a.k.a. homebrew)
export BREW_DIR="/opt/homebrew"
path_prepend "$BREW_DIR/bin"
path_prepend "$BREW_DIR/sbin"
export MANPATH="$BREW_DIR/share/man:$MANPATH"
export INFOPATH="$BREW_DIR/share/info:$INFOPATH"

# python and pyenv
# export PYENV_ROOT="$HOME/.pyenv"
# path_prepend "$PYENV_ROOT/bin"
if command -v pyenv &> /dev/null; then
  eval "$(pyenv init --path)"
  # eval "$(pyenv init -)"
fi

# docker
# export PATH="$BREW_DIR/opt/docker/bin:$PATH"
path_append "/Applications/Docker.app/Contents/Resources/bin"

# code (VSCode)
path_append "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# cmake
path_append "$BREW_DIR/opt/cmake/bin"

# dotnet
# export DOTNET_ROOT="$BREW_DIR/opt/dotnet-sdk"
path_append "$HOME/.dotnet/tools"

# llvm
path_append "$BREW_DIR/opt/llvm/bin"
export LDFLAGS="$LDFLAGS -L$BREW_DIR/opt/llvm/lib"
export CPPFLAGS="$CPPFLAGS -I$BREW_DIR/opt/llvm/include"

# openssl
path_append "$BREW_DIR/opt/openssl@3/bin"
export LDFLAGS="$LDFLAGS -L$BREW_DIR/opt/openssl@3/lib"
export CPPFLAGS="$CPPFLAGS -I$BREW_DIR/opt/openssl@3/include"

# ruby and rbenv
path_append "$BREW_DIR/opt/ruby/bin"
if command -v rbenv &> /dev/null; then
  eval "$(rbenv init -)"
fi

# bat (cat with syntax highlighting)
export LESSOPEN="| bat --paging=never %s"
export LESS=" -R "

# wireshark and tshark
# export PATH="$BREW_DIR/opt/wireshark/bin:$PATH"
path_append "/Applications/Wireshark.app/Contents/MacOS"
# sudo ln -s /Applications/Wireshark.app/Contents/MacOS/Wireshark /usr/local/bin/wireshark
# sudo ln -s /Applications/Wireshark.app/Contents/MacOS/tshark /usr/local/bin/tshark

# azure data studio
path_append "/Applications/Azure Data Studio.app/Contents/Resources/app/bin"

# cursor
path_append "/Applications/Cursor.app/Contents/Resources/app/bin"

# coteditor
path_append "/Applications/CotEditor.app/Contents/SharedSupport/bin"

#############################################################################
# HISTORY SETTINGS
#############################################################################

HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"

setopt HIST_IGNORE_ALL_DUPS  # Don't record duplicate commands
setopt HIST_FIND_NO_DUPS     # Don't show duplicates when searching
setopt HIST_IGNORE_SPACE     # Don't record commands starting with space
setopt HIST_SAVE_NO_DUPS     # Don't write duplicate entries in history file
setopt SHARE_HISTORY         # Share history between all sessions

#############################################################################
# DIRECTORY NAVIGATION OPTIONS
#############################################################################

setopt AUTO_CD              # If command is a path, cd into it
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack
setopt PUSHD_SILENT         # Do not print directory stack after pushd/popd

#############################################################################
# CUSTOM ENVs, FUNCTIONS AND ALIASES
#############################################################################

# define default locations for custom scripts
: ${SH_FUNCTIONS_DIR:="$HOME/.zsh_functions"}
: ${SH_ALIASES_DIR:="$HOME/.zsh_aliases"}
: ${AWS_HELPERS_DIR:="$HOME/.aws_helpers"}
: ${ESP_IDF_HELPERS_DIR:="$HOME/.esp_idf_helpers"}

# source custom scripts if they exist
# [[ -f "$HOME/.zshenv" ]] && source "$HOME/.zshenv"         # custom envs
[[ -f "$SH_FUNCTIONS_DIR" ]] && source "$SH_FUNCTIONS_DIR"   # custom functions
[[ -f "$SH_ALIASES_DIR" ]] && source "$SH_ALIASES_DIR"       # custom aliases

#############################################################################
# MODERN CLI TOOLS
#############################################################################

# use exa/eza instead of ls if available
if command -v eza &> /dev/null; then
  alias ls="eza --icons --group-directories-first"
  alias ll="eza -la --icons --group-directories-first"
  alias tree="eza --tree --icons"
elif command -v exa &> /dev/null; then
  alias ls="exa --icons --group-directories-first"
  alias ll="exa -la --icons --group-directories-first"
  alias tree="exa --tree --icons"
fi

# use bat instead of cat for better highlighting
if command -v bat &> /dev/null; then
  alias cat="bat --style=plain"
fi

# use fd instead of find for better performance
if command -v fd &> /dev/null; then
  alias find="fd"
fi

# use ripgrep instead of grep for better performance
if command -v rg &> /dev/null; then
  alias grep="rg"
fi

#############################################################################
# OH-MY-ZSH, PLUGINS AND CONFIGURATIONS
#############################################################################

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git fzf autojump direnv sudo tmux python pip virtualenv pyenv node npm yarn nvm golang rust gradle dotnet docker docker-compose kubectl zsh-syntax-highlighting zsh-history-substring-search fast-syntax-highlighting colored-man-pages alias-finder extract)
source $ZSH/oh-my-zsh.sh
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# history-substring-search plugin keybinds
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

#############################################################################
# COMPLETIONS
#############################################################################

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"    # Colored completion
zstyle ':completion:*' rehash true                         # Automatically find new executables in path 
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

#############################################################################
# NAVIGATION TOOLS AND INTEGRATIONS
#############################################################################

# fzf integration
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# choose ONE navigation tool - either zoxide OR autojump, not both
if command -v zoxide &> /dev/null; then
  # use zoxide (more modern tool)
  [[ -f "$BREW_DIR/etc/profile.d/zoxide.sh" ]] && source "$BREW_DIR/etc/profile.d/zoxide.sh"
  eval "$(zoxide init zsh)"
  # don't create alias j="z" as it conflicts with autojump
else
  # only use autojump if zoxide isn't available
  [[ -f /usr/share/autojump/autojump.zsh ]] && source /usr/share/autojump/autojump.zsh
fi

#############################################################################
# DEVELOPMENT TOOLS, FRAMEWORKS, SDKs AND ENVIRONMENTS
#############################################################################

# lazy load NVM to improve startup time
export NVM_DIR="$HOME/.nvm"
# create aliases that will load nvm only when needed
alias node='unalias node npm nvm yarn 2>/dev/null; nvm_load; node'
alias npm='unalias node npm nvm yarn 2>/dev/null; nvm_load; npm'
alias nvm='unalias node npm nvm yarn 2>/dev/null; nvm_load; nvm'
alias yarn='unalias node npm nvm yarn 2>/dev/null; nvm_load; yarn'

# aws
[[ -f "$AWS_HELPERS_DIR" ]] && source "$AWS_HELPERS_DIR"

# esp-idf
[[ -f "$ESP_IDF_HELPERS_DIR" ]] && source "$ESP_IDF_HELPERS_DIR"

# direnv for environment management
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# amazon q post block. keep at the bottom of this file
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

## eof
