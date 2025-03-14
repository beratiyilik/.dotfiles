# [[ -f "$SHENV_DIR" ]] && source "$SHENV_DIR"
# [[ -f "$HOME/.zshenv" ]] && source "$HOME/.zshenv"

#############################################################################
# USER INFORMATION
#############################################################################
export USER_USERNAME="beratiyilik"
export USER_FULLNAME="Berat Iyilik"
export USER_EMAIL=""

#############################################################################
# PATH CONFIGURATION
#############################################################################
# export PATH="$HOME/.local/bin:$PATH"
# export PATH="$HOME/.npm-global/bin:$PATH"
# export PATH="$HOME/.cargo/bin:$PATH"
# export GOPATH="$HOME/go"
# export PATH="$GOPATH/bin:$PATH"

#############################################################################
# WORKSPACE & DIRECTORY STRUCTURE
#############################################################################
export WORKSPACE="repos"
export WORKSPACE_DIR="$HOME/$WORKSPACE"

#############################################################################
# SHELL CONFIGURATION
#############################################################################
# shell file names
export SHENV=".zshenv"
export SHRC=".zshrc"
export SH_FUNCTIONS=".zsh_functions"
export SH_ALIASES=".zsh_aliases"

# shell file paths
export SHENV_DIR="$HOME/$SHENV"
export SHRC_DIR="$HOME/$SHRC"
export SH_FUNCTIONS_DIR="$HOME/$SH_FUNCTIONS"
export SH_ALIASES_DIR="$HOME/$SH_ALIASES"

#############################################################################
# DEVELOPMENT TOOLS CONFIGURATION
#############################################################################
# git configuration
export GITCONFIG_DIR="$HOME/.gitconfig"
export GITHUB_HOSTNAME="https://github.com/"
export GITHUB_GIST_HOSTNAME="https://gist.github.com/"
export GITHUB_GIST_GITHUBUSERCONTENT_HOSTNAME="https://gist.githubusercontent.com/"
export GITHUB_PERSONAL_ACCESS_TOKEN=""

# npm configuration
export NPM_ACCESS_TOKEN=""

# ssh configuration
export SHH_CONFIG_DIR="$HOME/.ssh/config"

# aws configuration
export AWS_HELPERS_DIR="$HOME/.aws/.aws_helpers"

# esp-idf configuration
export ESP_IDF_HELPERS_DIR="$HOME/esp/.esp_idf_helpers"

#############################################################################
# TERMINAL APPEARANCE
#############################################################################
# colors
export NC="\033[0m"
export BLACK="\033[0;30m"
export RED="\033[0;31m"
export GREEN="\033[0;32m"
export YELLOW="\033[0;33m"
export BLUE="\033[0;34m"
export MAGENTA="\033[0;35m"
export CYAN="\033[0;36m"
export WHITE="\033[0;37m"

# text formatting
export BOLD="\033[1m"
export UNDERLINE="\033[4m"
export INVERT="\033[7m"
export BLINK="\033[5m"
export HIDDEN="\033[8m"

#############################################################################
# FORMATS
#############################################################################

export LONG_DATE_FORMAT="%a %b %d %Y %H:%M:%S %I:%M %p %Z"
export SHORT_DATE_FORMAT="%a %b %d %Y"

## eof
