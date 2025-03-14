# Dotfiles

A collection of personal dotfiles and configuration files for various tools and environments.

## Overview

This repository contains my personal dotfiles and configuration files for tools like zsh, vim, git, AWS CLI, and ESP-IDF. It includes an installation script that creates symlinks to these files in your home directory, making it easy to set up a consistent environment across different machines.

## What's Included

- **Shell Configuration**:
  - `.zshrc`: Main Zsh configuration
  - `.zshenv`: Environment variables 
  - `.zprofile`: Login shell configuration
  - `.zsh_aliases`: Aliases for common commands
  - `.zsh_functions`: Custom Zsh functions

- **Editor Configuration**:
  - `.vimrc`: Vim configuration
  - `.nanorc`: Nano configuration

- **Git Configuration**:
  - `.gitconfig`: Git aliases and settings
  - `.gitignore`: Global Git ignore patterns

- **Development Tools**:
  - `.aws/.aws_helpers`: AWS CLI profile management functions
  - `esp/.esp_idf_helpers`: ESP32/ESP8266 development environment helpers

## Installation

Clone the repository to your preferred location:

```bash
git clone https://github.com/beratiyilik/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

Run the installation script:

```bash
chmod +x init.sh

./init.sh
```

### Installation Options

The `init.sh` script supports several options:

```bash
./init.sh --help           # Display help message
./init.sh --dry-run        # Show what changes would be made without applying them
./init.sh --force          # Overwrite existing files without creating backups
./init.sh --interactive    # Prompt before making changes
./init.sh --config=FILE    # Use an alternative config file
```

## Features

### ZSH Configuration

- Modern CLI alternatives (exa/eza, bat, fd, ripgrep) when available
- Comprehensive aliases for file operations, git, network utilities, etc.
- Custom functions for archive management, path management, and more
- Integration with Oh-My-ZSH and Powerlevel10k theme
- Lazy loading for NVM to improve startup time

### Development Environment

- AWS profile management with `awsm` command
- ESP32/ESP8266 environment switching with `esp` command
- Git aliases and shortcuts
- Path management utilities

## Customization

You can customize the dotfiles installation by creating or modifying `dotfiles.conf`. This file allows you to specify which dotfiles to symlink and other configuration options.

## Backup

The installation script automatically creates backups of your existing dotfiles before replacing them with symlinks. Backups are stored in `~/.dotfiles/backup/YYYYMMDD-HHMMSS/`.

## License

MIT
