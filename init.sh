#!/usr/bin/env bash

# ensure we're running in bash
if [ -z "${BASH_VERSION}" ]; then
    echo "This script requires bash" >&2
    exit 1
fi

# get the directory of the script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_DIR="$SCRIPT_DIR"
BACKUP_DIR="$HOME/.dotfiles/backup/$(date +%Y%m%d-%H%M%S)"
CONFIG_FILE="$DOTFILES_DIR/dotfiles.conf"

# default list of dotfiles to symlink (can be overridden by config file)
dotfiles=(
    ".zshrc"
    ".zshenv"
    ".zprofile"
    ".zsh_aliases"
    ".zsh_functions"
    ".vimrc"
    ".nanorc"
    ".gitconfig"
    ".aws/.aws_helpers"
    "esp/.esp_idf_helpers"
)

# configuration options
FORCE_MODE=false
DRY_RUN=false
INTERACTIVE=false
TOTAL_FILES=0
CURRENT_FILE=0

# colors for output
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_info() {
  echo -e "${BLUE}[INFO] $1${NC}"
}

log_success() {
  echo -e "${GREEN}[SUCCESS] $1${NC}"
}

log_warn() {
  echo -e "${YELLOW}[WARNING] $1${NC}"
}

log_error() {
  echo -e "${RED}[ERROR] $1${NC}" >&2
}

show_progress() {
  CURRENT_FILE=$((CURRENT_FILE + 1))
  printf "[%3d%%] Processing %s\n" $(( CURRENT_FILE * 100 / TOTAL_FILES )) "$1"
}

# check if directory exists
dir_exists() {
    if [ -d "$1" ]; then
        return 0  # True
    else
        return 1  # False
    fi
}

# check if file exists (including symlinks)
file_exists() {
    if [ -e "$1" ]; then
        return 0  # True
    else
        return 1  # False
    fi
}

# check if path is a symlink
is_symlink() {
    if [ -L "$1" ]; then
        return 0  # True
    else
        return 1  # False
    fi
}

# check if path is a regular file (not a symlink, directory, etc.)
is_regular_file() {
    if [ -f "$1" ] && [ ! -L "$1" ]; then
        return 0  # True
    else
        return 1  # False
    fi
}

# create directory if it doesn't exist
ensure_dir_exists() {
    if ! dir_exists "$1"; then
        if [ "$DRY_RUN" = true ]; then
            log_info "[DRY RUN] Would create directory: $1"
            return 0
        fi
        
        mkdir -p "$1"
        if [ $? -eq 0 ]; then
            log_info "Created directory: $1"
            return 0
        else
            log_error "Failed to create directory: $1"
            return 1
        fi
    fi
    return 0
}

# backup a file with timestamp
backup_file() {
    local file="$1"
    local backup_dir="$2"
    
    if [ "$FORCE_MODE" = true ]; then
        log_info "Force mode: skipping backup of $file"
        return 0
    fi
    
    if [ -z "$backup_dir" ]; then
        backup_dir="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
    fi
    
    if file_exists "$file"; then
        if [ "$DRY_RUN" = true ]; then
            log_info "[DRY RUN] Would backup $file to $backup_dir"
            return 0
        fi
        
        ensure_dir_exists "$backup_dir"
        local filename=$(basename "$file")
        local backup_path="$backup_dir/$filename"
        
        cp -R "$file" "$backup_path"
        if [ $? -eq 0 ]; then
            log_success "Backed up $file to $backup_path"
            return 0
        else
            log_error "Failed to backup $file"
            return 1
        fi
    else
        log_warn "File $file doesn't exist, skipping backup"
        return 2
    fi
}

# ask user for confirmation
confirm_action() {
    local message="$1"
    local default_answer="$2"  # should be "y" or "n"
    
    if [ "$INTERACTIVE" != true ]; then
        return 0
    fi
    
    local prompt
    if [ "$default_answer" = "y" ]; then
        prompt="$message [Y/n]: "
    else
        prompt="$message [y/N]: "
    fi
    
    read -p "$prompt" response
    response=${response,,}  # convert to lowercase
    
    if [ -z "$response" ]; then
        response=$default_answer
    fi
    
    if [[ "$response" =~ ^(yes|y)$ ]]; then
        return 0
    else
        return 1
    fi
}

# create a symlink with safety checks
create_symlink() {
    local source="$1"  # source file in dotfiles repo
    local target="$2"  # target location (usually in home dir)
    local backup_dir="$3"  # optional backup directory
    
    # check if source exists
    if ! file_exists "$source"; then
        log_error "Source file $source doesn't exist"
        return 1
    fi
    
    # if target already exists and is a symlink
    if is_symlink "$target"; then
        local current_source=$(readlink "$target")
        if [ "$current_source" = "$source" ]; then
            log_info "Link already exists: $target -> $source"
            return 0
        else
            log_warn "Different symlink exists: $target -> $current_source"
            if confirm_action "Replace existing symlink?" "y"; then
                backup_file "$target" "$backup_dir"
            else
                log_info "Skipping $target"
                return 0
            fi
        fi
    # if target exists as a regular file/directory
    elif file_exists "$target"; then
        log_warn "File/directory exists at $target"
        if confirm_action "Replace existing file/directory?" "n"; then
            backup_file "$target" "$backup_dir"
        else
            log_info "Skipping $target"
            return 0
        fi
    fi
    
    # create parent directory if it doesn't exist
    local target_dir=$(dirname "$target")
    ensure_dir_exists "$target_dir"
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    # create the symlink
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY RUN] Would create symlink: $target -> $source"
        return 0
    fi
    
    ln -sf "$source" "$target"
    if [ $? -eq 0 ]; then
        log_success "Created symlink: $target -> $source"
        return 0
    else
        log_error "Failed to create symlink for $target"
        return 1
    fi
}

# verify that dotfiles exist
verify_dotfiles() {
    local missing_files=0
    
    for file in "${dotfiles[@]}"; do
        source_file="$DOTFILES_DIR/$file"
        if ! file_exists "$source_file"; then
            log_error "Dotfile doesn't exist: $source_file"
            missing_files=$((missing_files + 1))
        fi
    done
    
    if [ $missing_files -gt 0 ]; then
        log_warn "Found $missing_files missing dotfile(s)"
        if confirm_action "Continue anyway?" "n"; then
            return 0
        else
            log_error "Aborting due to missing dotfiles"
            return 1
        fi
    fi
    
    return 0
}

# check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# verify symlinks are working properly
verify_installation() {
    local errors=0
    
    log_info "Verifying installation..."
    
    for file in "${dotfiles[@]}"; do
        local target_file="$HOME/$file"
        
        if ! is_symlink "$target_file"; then
            log_error "Not a symlink: $target_file"
            errors=$((errors + 1))
            continue
        fi
        
        local link_target=$(readlink "$target_file")
        local expected_target="$DOTFILES_DIR/$file"
        
        if [ "$link_target" != "$expected_target" ]; then
            log_error "Incorrect symlink target: $target_file -> $link_target (expected $expected_target)"
            errors=$((errors + 1))
        fi
    done
    
    if [ $errors -eq 0 ]; then
        log_success "All symlinks verified successfully!"
        return 0
    else
        log_warn "Found $errors error(s) in symlink verification"
        return 1
    fi
}

# add OS-specific dotfiles
add_os_specific_dotfiles() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        log_info "Detected macOS - adding OS-specific dotfiles"
        if file_exists "$DOTFILES_DIR/.macos"; then
            dotfiles+=(".macos")
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        log_info "Detected Linux - adding OS-specific dotfiles"
        if file_exists "$DOTFILES_DIR/.linux"; then
            dotfiles+=(".linux")
        fi
    fi
}

# load external config if it exists
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        log_info "Loading configuration from $CONFIG_FILE"
        source "$CONFIG_FILE"
    else
        log_info "Using default configuration (no config file found at $CONFIG_FILE)"
    fi
}

# main function to setup dotfiles
setup_dotfiles() {
    log_info "Setting up dotfiles from $DOTFILES_DIR"
    
    # load config file if it exists
    load_config
    
    # add OS-specific dotfiles
    add_os_specific_dotfiles
    
    TOTAL_FILES=${#dotfiles[@]}
    log_info "Found $TOTAL_FILES dotfiles to process"
    
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY RUN] No changes will be made"
    fi
    
    # verify dotfiles exist
    verify_dotfiles
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    # create backup directory
    if [ "$FORCE_MODE" != true ]; then
        log_info "Backups will be stored in $BACKUP_DIR"
        ensure_dir_exists "$BACKUP_DIR"
        if [ $? -ne 0 ]; then
            return 1
        fi
    fi
    
    # process each dotfile
    local errors=0
    for file in "${dotfiles[@]}"; do
        show_progress "$file"
        
        # handle nested paths
        if [[ "$file" == */* ]]; then
            # get the directory part and create it
            dir_part=$(dirname "$file")
            ensure_dir_exists "$HOME/$dir_part"
            
            # get source and target paths
            source_file="$DOTFILES_DIR/$file"
            target_file="$HOME/$file"
        else
            source_file="$DOTFILES_DIR/$file"
            target_file="$HOME/$file"
        fi
        
        create_symlink "$source_file" "$target_file" "$BACKUP_DIR"
        if [ $? -ne 0 ]; then
            errors=$((errors + 1))
        fi
    done
    
    # verify installation if not in dry-run mode
    if [ "$DRY_RUN" = false ]; then
        verify_installation
    fi
    
    if [ $errors -eq 0 ]; then
        log_success "Dotfiles setup completed successfully!"
        return 0
    else
        log_warn "Dotfiles setup completed with $errors error(s)"
        return 1
    fi
}

# display help
show_help() {
    cat << EOF
Usage: $0 [OPTION]
Set up dotfiles by creating symlinks in your home directory.

Options:
  --help, -h       Display this help message
  --force, -f      Force overwrite of existing files without backup (Default: false)
  --dry-run, -d    Show what would be done without making changes (Default: false)
  --interactive, -i Prompt before making changes (Default: false)
  --config=FILE    Use an alternative config file (Default: $DOTFILES_DIR/dotfiles.conf)

Examples:
  $0               Setup dotfiles with default settings
  $0 --dry-run     Show what changes would be made without applying them
  $0 --force       Overwrite existing files without creating backups
  $0 --config=/path/to/custom.conf  Use a custom configuration file
EOF
}

# parse command line arguments
parse_args() {
    while [ "$#" -gt 0 ]; do
        case "$1" in
            --help|-h)
                show_help
                exit 0
                ;;
            --force|-f)
                FORCE_MODE=true
                log_info "Force mode enabled - no backups will be created"
                shift
                ;;
            --dry-run|-d)
                DRY_RUN=true
                shift
                ;;
            --interactive|-i)
                INTERACTIVE=true
                shift
                ;;
            --config=*)
                CONFIG_FILE="${1#*=}"
                if [ ! -f "$CONFIG_FILE" ]; then
                    log_error "Config file not found: $CONFIG_FILE"
                    exit 1
                fi
                shift
                ;;
            *)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # check for required dependencies
    for cmd in ln mkdir cp readlink; do
        if ! command_exists "$cmd"; then
            log_error "Required command '$cmd' not found in PATH"
            exit 1
        fi
    done
    
    # run the setup
    setup_dotfiles
    exit $?
}

# run the script
parse_args "$@"

## eof
