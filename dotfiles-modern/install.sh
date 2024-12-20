#!/bin/bash

# Modern dotfiles installation script
# Supports Python (poetry), Node.js (pnpm), and Rust development

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Installing modern development environment...${NC}"

# Check OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS-specific setup
    if ! command -v brew >/dev/null 2>&1; then
        echo -e "${BLUE}Installing Homebrew...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    
    echo -e "${BLUE}Installing packages from Brewfile...${NC}"
    brew bundle

    # Install macOS command line tools
    if ! command -v xcode-select >/dev/null 2>&1; then
        echo -e "${BLUE}Installing Command Line Tools...${NC}"
        xcode-select --install
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux-specific setup
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y build-essential curl file git
    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf groupinstall "Development Tools"
        sudo dnf install -y curl file git
    fi
fi

# Create development directories
mkdir -p ~/.local/share/dev-environments

# Install Python tooling
if ! command -v pyenv >/dev/null 2>&1; then
    echo -e "${BLUE}Installing pyenv...${NC}"
    curl https://pyenv.run | bash
    
    # Add pyenv to shell configuration
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
fi

if ! command -v poetry >/dev/null 2>&1; then
    echo -e "${BLUE}Installing Poetry...${NC}"
    curl -sSL https://install.python-poetry.org | python3 -
    
    # Configure poetry to create virtual environments in project directories
    poetry config virtualenvs.in-project true
fi

# Install Node.js tooling
if ! command -v fnm >/dev/null 2>&1; then
    echo -e "${BLUE}Installing Fast Node Manager (fnm)...${NC}"
    curl -fsSL https://fnm.vercel.app/install | bash
    
    # Add fnm to shell configuration
    echo 'eval "$(fnm env --use-on-cd)"' >> ~/.zshrc
fi

if ! command -v pnpm >/dev/null 2>&1; then
    echo -e "${BLUE}Installing pnpm...${NC}"
    curl -fsSL https://get.pnpm.io/install.sh | sh -
    
    # Configure pnpm to store global packages in user directory
    pnpm config set store-dir ~/.local/share/pnpm-store
fi

# Install Rust tooling
if ! command -v rustup >/dev/null 2>&1; then
    echo -e "${BLUE}Installing Rust toolchain...${NC}"
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
    
    # Install common Rust tools
    cargo install cargo-watch cargo-edit cargo-update
fi

# Install modern shell tools
if ! command -v zoxide >/dev/null 2>&1; then
    echo -e "${BLUE}Installing zoxide (smart cd)...${NC}"
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
fi

if ! command -v starship >/dev/null 2>&1; then
    echo -e "${BLUE}Installing Starship prompt...${NC}"
    curl -sS https://starship.rs/install.sh | sh
    echo 'eval "$(starship init zsh)"' >> ~/.zshrc
fi

# Set up Docker with rootless mode
if ! command -v docker >/dev/null 2>&1; then
    echo -e "${BLUE}Setting up Docker in rootless mode...${NC}"
    curl -fsSL https://get.docker.com/rootless | sh
    
    # Add Docker to shell configuration
    echo 'export PATH=/home/$USER/bin:$PATH' >> ~/.zshrc
    echo 'export DOCKER_HOST=unix:///run/user/$UID/docker.sock' >> ~/.zshrc
fi

# Link configuration files
echo -e "${BLUE}Linking configuration files...${NC}"

# Git configuration
ln -sf "$(pwd)/git/gitconfig" ~/.gitconfig
ln -sf "$(pwd)/git/gitignore" ~/.gitignore

# Shell configuration
mkdir -p ~/.config/zsh
for file in zsh/*.zsh; do
    ln -sf "$(pwd)/$file" ~/.config/zsh/
done

# Tmux configuration
ln -sf "$(pwd)/tmux/tmux.conf" ~/.tmux.conf
if [[ "$OSTYPE" == "darwin"* ]]; then
    ln -sf "$(pwd)/tmux/.tmux-macos" ~/.tmux-macos
else
    ln -sf "$(pwd)/tmux/.tmux-linux" ~/.tmux-linux
fi

# Development tools configuration
mkdir -p ~/.config/{nvim,starship}
ln -sf "$(pwd)/javascript/eslintrc" ~/.eslintrc
ln -sf "$(pwd)/javascript/prettierrc" ~/.prettierrc

# Create a basic Starship configuration
cat > ~/.config/starship.toml << EOF
format = """
[┌───────────────────>](bold green)
[│](bold green)$directory$git_branch$git_status
[└─>](bold green) """
EOF

echo -e "${GREEN}Installation complete! Please restart your shell.${NC}"