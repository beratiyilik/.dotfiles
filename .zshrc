# amazon q pre block. keep at the top of this file
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"

# powerlevel10k instant prompt (keep at the top for speed)
[[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]] && source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

#############################################################################
# HELPER FUNCTIONS
#############################################################################

# prepend a directory to the PATH environment variable if it exists
_prepend_to_path() {
  if [[ -d "$1" && ! "$PATH" =~ (^|:)"$1"(:|$) ]]; then
    PATH="$1:$PATH"
    export PATH
  fi
}

# append a directory to the PATH environment variable if it exists
_append_to_path() {
  if [[ -d "$1" && ! "$PATH" =~ (^|:)"$1"(:|$) ]]; then
    PATH="$PATH:$1"
    export PATH
  fi
}

# lazy loading function for nvm
_load_nvm() {
  export NVM_DIR="$HOME/.nvm"
  [[ -s "$BREW_DIR/opt/nvm/nvm.sh" ]] && source "$BREW_DIR/opt/nvm/nvm.sh"
  [[ -s "$BREW_DIR/opt/nvm/etc/bash_completion.d/nvm" ]] && source "$BREW_DIR/opt/nvm/etc/bash_completion.d/nvm"
}

#############################################################################
# SHELL CONFIGURATION
#############################################################################

# history settings
HISTSIZE=10000				        # number of commands to remember
SAVEHIST=10000				        # number of commands to save to history file
HISTFILE="$HOME/.zsh_history" # history file location

# history options
setopt HIST_IGNORE_ALL_DUPS # don't record duplicate commands
setopt HIST_FIND_NO_DUPS    # don't show duplicates when searching
setopt HIST_IGNORE_SPACE    # don't record commands starting with space
setopt HIST_SAVE_NO_DUPS    # don't write duplicate entries in history file
setopt SHARE_HISTORY        # share history between all sessions

# directory navigation options
setopt AUTO_CD            # if command is a path, cd into it
setopt AUTO_PUSHD         # push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS  # do not store duplicates in the stack
setopt PUSHD_SILENT       # do not print directory stack after pushd/popd

#############################################################################
# CORE ENVIRONMENT SETUP
#############################################################################

# common flags - initialize if not set
[[ -z "$LDFLAGS" ]] && export LDFLAGS=""
[[ -z "$CPPFLAGS" ]] && export CPPFLAGS=""

# brew (a.k.a. homebrew)
export BREW_DIR="/opt/homebrew"
_prepend_to_path "$BREW_DIR/bin"
_prepend_to_path "$BREW_DIR/sbin"
export MANPATH="$BREW_DIR/share/man:$MANPATH"
export INFOPATH="$BREW_DIR/share/info:$INFOPATH"

#############################################################################
# DEVELOPMENT TOOLS
#############################################################################

# python and pyenv
# export PYENV_ROOT="$HOME/.pyenv"
# _prepend_to_path "$PYENV_ROOT/bin"
if command -v pyenv >/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  # eval "$(pyenv init -)"
fi

# node.js and nvm (lazy loaded)
export NVM_DIR="$HOME/.nvm"
# aliases that will load nvm only when needed
alias node='unalias node npm nvm yarn 2>/dev/null; _load_nvm; node'
alias npm='unalias node npm nvm yarn 2>/dev/null; _load_nvm; npm'
alias nvm='unalias node npm nvm yarn 2>/dev/null; _load_nvm; nvm'
alias yarn='unalias node npm nvm yarn 2>/dev/null; _load_nvm; yarn'

# ruby and rbenv
_append_to_path "$BREW_DIR/opt/ruby/bin"
command -v rbenv >/dev/null 2>&1 && eval "$(rbenv init -)"

# docker
# export PATH="$BREW_DIR/opt/docker/bin:$PATH"
_append_to_path "/Applications/Docker.app/Contents/Resources/bin"

# llvm
_append_to_path "$BREW_DIR/opt/llvm/bin"
export LDFLAGS="$LDFLAGS -L$BREW_DIR/opt/llvm/lib"
export CPPFLAGS="$CPPFLAGS -I$BREW_DIR/opt/llvm/include"

# openssl
_append_to_path "$BREW_DIR/opt/openssl@3/bin"
export LDFLAGS="$LDFLAGS -L$BREW_DIR/opt/openssl@3/lib"
export CPPFLAGS="$CPPFLAGS -I$BREW_DIR/opt/openssl@3/include"

# cmake
_append_to_path "$BREW_DIR/opt/cmake/bin"

# dotnet
# export DOTNET_ROOT="$BREW_DIR/opt/dotnet-sdk"
_append_to_path "$HOME/.dotnet/tools"

#############################################################################
# APPLICATIONS
#############################################################################

# code (VSCode)
_append_to_path "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# cursor
_append_to_path "/Applications/Cursor.app/Contents/Resources/app/bin"

# bat (cat with syntax highlighting)
export LESSOPEN="| bat --paging=never %s"
export LESS=" -R "

# wireshark and tshark
# export PATH="$BREW_DIR/opt/wireshark/bin:$PATH"
_append_to_path "/Applications/Wireshark.app/Contents/MacOS"
# sudo ln -s /Applications/Wireshark.app/Contents/MacOS/Wireshark /usr/local/bin/wireshark
# sudo ln -s /Applications/Wireshark.app/Contents/MacOS/tshark /usr/local/bin/tshark

# azure data studio
_append_to_path "/Applications/Azure Data Studio.app/Contents/Resources/app/bin"

# coteditor
_append_to_path "/Applications/CotEditor.app/Contents/SharedSupport/bin"

#############################################################################
# OH-MY-ZSH, PLUGINS AND CONFIGURATIONS
#############################################################################

export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  git fzf autojump direnv sudo tmux 
  python pip virtualenv pyenv 
  node npm yarn nvm 
  golang rust gradle dotnet 
  docker docker-compose kubectl 
  zsh-syntax-highlighting zsh-history-substring-search fast-syntax-highlighting 
  colored-man-pages alias-finder extract
)
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

#############################################################################
# COMPLETION AND NAVIGATION
#############################################################################

# history substring search keybinds
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # colored completion
zstyle ':completion:*' rehash true                        # automatically find new executables in path 
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# fzf integration
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# navigation tool - either zoxide or autojump, not both
if command -v zoxide >/dev/null 2>&1; then
  [[ -f "$BREW_DIR/etc/profile.d/zoxide.sh" ]] && source "$BREW_DIR/etc/profile.d/zoxide.sh"
  eval "$(zoxide init zsh)"
  # don't create alias j="z" as it conflicts with autojump
else
  [[ -f "/usr/share/autojump/autojump.zsh" ]] && source "/usr/share/autojump/autojump.zsh"
fi

# direnv for environment management
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

#############################################################################
# CUSTOM SCRIPTS
#############################################################################

# define default locations for custom scripts
SH_FUNCTIONS_DIR="${SH_FUNCTIONS_DIR:-$HOME/.zsh_functions}"
SH_ALIASES_DIR="${SH_ALIASES_DIR:-$HOME/.zsh_aliases}"
AWS_HELPERS_DIR="${AWS_HELPERS_DIR:-$HOME/.aws/.aws_helpers}"
ESP_IDF_HELPERS_DIR="${ESP_IDF_HELPERS_DIR:-$HOME/.esp/.esp_idf_helpers}"

# source custom scripts if they exist
[[ -f "$SH_FUNCTIONS_DIR" ]] && source "$SH_FUNCTIONS_DIR"   # custom functions
[[ -f "$SH_ALIASES_DIR" ]] && source "$SH_ALIASES_DIR"       # custom aliases
[[ -f "$AWS_HELPERS_DIR" ]] && source "$AWS_HELPERS_DIR"     # aws helpers
[[ -f "$ESP_IDF_HELPERS_DIR" ]] && source "$ESP_IDF_HELPERS_DIR" # esp-idf helpers

# amazon q post block. keep at the bottom of this file
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"

## eof
