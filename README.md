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
chmod +x init.sh           # make the script executable
./init.sh                  # install dotfiles with default options
```

### Installation Options

The `init.sh` script supports several options:

```bash
./init.sh --help           # display help message
./init.sh --dry-run        # show what changes would be made without applying them
./init.sh --force          # overwrite existing files without creating backups
./init.sh --interactive    # prompt before making changes
./init.sh --config=FILE    # use an alternative config file
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

## Manifest

Our goal is to deliver a well-crafted, intuitive dotfiles management system, leveraging modern Bash and Zsh, specifically targeting macOS (Zsh), Ubuntu (Bash), and Debian (Bash). By prioritizing clarity and efficiency, we ensure seamless customization and portability across these environments.

## License

MIT
