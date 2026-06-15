#!/usr/bin/env bash

# Set strict error handling
set -euo pipefail
IFS=$'\n\t'

# Get the directory where the script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Terminal colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Error handler
handle_error() {
    log_error "An error occurred on line $1"
    exit 1
}

trap 'handle_error $LINENO' ERR

# Check if running on macOS
check_platform() {
    if [[ "$(uname)" != "Darwin" ]]; then
        log_error "This script is intended for macOS only"
        exit 1
    fi
}

# Check for Command Line Tools
check_xcode_cli() {
    if ! xcode-select -p &> /dev/null; then
        log_info "Installing Command Line Tools..."
        xcode-select --install
        log_warning "Please complete the Command Line Tools installation and run this script again."
        exit 0
    fi
}

# Install Homebrew if not installed
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        log_info "Homebrew is already installed, updating..."
        brew update
    fi
}

# Install dependencies from Brewfile
install_dependencies() {
    log_info "Installing dependencies from Brewfile..."
    if [ -f "${DOTFILES_DIR}/Brewfile" ]; then
        cd "${DOTFILES_DIR}" && brew bundle
    else
        log_error "Brewfile not found"
        exit 1
    fi
}

# Set up zsh and powerlevel10k
setup_shell() {
    log_info "Setting up shell environment..."
    
    # Set zsh as default shell if it isn't already
    if [[ "$SHELL" != *"zsh"* ]]; then
        log_info "Setting zsh as default shell..."
        if ! grep -q "$(which zsh)" /etc/shells; then
            echo "$(which zsh)" | sudo tee -a /etc/shells
        fi
        chsh -s "$(which zsh)"
    fi

    # Create necessary config directories
    mkdir -p "${HOME}/.config"
    mkdir -p "${HOME}/.config/ghostty"

    # Backup existing configurations
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir="${HOME}/.dotfiles_backup_${timestamp}"

    if [ -f "${HOME}/.zshrc" ] || [ -f "${HOME}/.p10k.zsh" ]; then
        log_info "Backing up existing configurations to ${backup_dir}"
        mkdir -p "${backup_dir}"
        [ -f "${HOME}/.zshrc" ] && mv "${HOME}/.zshrc" "${backup_dir}/"
        [ -f "${HOME}/.p10k.zsh" ] && mv "${HOME}/.p10k.zsh" "${backup_dir}/"
    fi

    # Symlink configuration files
    log_info "Creating symlinks for configuration files..."
    ln -sf "${DOTFILES_DIR}/.zshrc" "${HOME}/.zshrc"
    ln -sf "${DOTFILES_DIR}/.p10k.zsh" "${HOME}/.p10k.zsh"
    ln -sf "${DOTFILES_DIR}/.tmux.conf" "${HOME}/.tmux.conf"

}

# Set up Node.js environment with fnm and pnpm
setup_nodejs() {
    log_info "Setting up Node.js environment..."
    
    # Initialize fnm
    eval "$(fnm env --use-on-cd)"
    
    # Install latest LTS version of Node.js
    fnm install --lts
    fnm default lts-latest
    

}

# Install Claude Code CLI
setup_claude_code() {
    log_info "Installing Claude Code CLI..."
    eval "$(fnm env --use-on-cd)"
    npm install -g @anthropic-ai/claude-code
}

# Set up Python environment with Poetry and pyenv
setup_python() {
    log_info "Setting up Python environment..."
    
    # Initialize pyenv
    if command -v pyenv &> /dev/null; then
        eval "$(pyenv init -)"
        
        # Install latest stable Python version
        latest_python=$(pyenv install --list | grep -v '[a-zA-Z]' | grep -v - | tail -1 | xargs)
        pyenv install $latest_python
        pyenv global $latest_python
    else
        log_error "pyenv not found. Please ensure it was installed via Homebrew"
        exit 1
    fi
    
    # Configure Poetry
    if command -v poetry &> /dev/null; then
        poetry config virtualenvs.in-project true
        poetry config virtualenvs.create true
    else
        log_error "Poetry not found. Please ensure it was installed via Homebrew"
        exit 1
    fi
}

# Set up Rust environment
setup_rust() {
    log_info "Setting up Rust environment..."
    
    # Install Rust using rustup if not already installed
    if ! command -v rustup &> /dev/null; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi
    
    # Install common Rust components
    rustup component add rustfmt clippy rust-analyzer
}

# Set up Java environment with SDKman
setup_java() {
    log_info "Setting up Java environment..."
    
    local brew_bash
    if [ -x "/opt/homebrew/bin/bash" ]; then
        brew_bash="/opt/homebrew/bin/bash"
    else
        brew_bash="/usr/local/bin/bash"
    fi

    # Install SDKman if not already installed
    if [ ! -d "$HOME/.sdkman" ]; then
        curl -s "https://get.sdkman.io" | "$brew_bash"
    fi

    # Install latest LTS version of Java (SDKman requires Bash 4+)
    "$brew_bash" -c 'source "$HOME/.sdkman/bin/sdkman-init.sh" && sdk install java'
}

# Main installation function
main() {
    echo "Starting dotfiles installation..."
    
    check_platform
    check_xcode_cli
    install_homebrew
    install_dependencies
    setup_rust
    setup_nodejs
    setup_claude_code
    setup_python
    setup_java
    setup_shell
    
    log_success "Installation complete!"
    log_warning "Please restart your terminal for all changes to take effect."
    log_info "Your previous configuration files (if any) have been backed up."
}

# Run main function
if [[ "${1:-}" != "" ]]; then
    "$1"
else
    main
fi