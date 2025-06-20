#!/bin/bash

# Enhanced Perfect ZSH Setup Script for macOS
# Interactive, configurable, and comprehensive development environment setup

set -e  # Exit on error

# =======================================
# Configuration
# =======================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/config/setup.conf"
LIB_DIR="$SCRIPT_DIR/lib"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# =======================================
# Helper Functions
# =======================================
print_banner() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                    Perfect ZSH Setup                        ║"
    echo "║            Interactive macOS Development Environment         ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "\n${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_info() {
    echo -e "${CYAN}ℹ${NC} $1"
}

# =======================================
# Utility Functions
# =======================================
check_macos() {
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script is designed for macOS only"
        exit 1
    fi
}

check_dependencies() {
    print_step "Checking dependencies..."
    
    # Check if we can create directories
    mkdir -p "$SCRIPT_DIR/lib" "$SCRIPT_DIR/config/presets" "$SCRIPT_DIR/logs"
    
    # Check if config file exists, create default if not
    if [ ! -f "$CONFIG_FILE" ]; then
        print_warning "Configuration file not found, creating default..."
        cp "$SCRIPT_DIR/config/setup.conf" "$CONFIG_FILE" 2>/dev/null || {
            print_error "Could not find configuration template"
            exit 1
        }
    fi
    
    print_success "Dependencies checked"
}

load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        print_step "Loading configuration..."
        source "$CONFIG_FILE"
        print_success "Configuration loaded from $CONFIG_FILE"
    else
        print_error "Configuration file not found: $CONFIG_FILE"
        exit 1
    fi
}

# =======================================
# Logging
# =======================================
setup_logging() {
    local log_dir="$SCRIPT_DIR/logs"
    mkdir -p "$log_dir"
    
    LOG_FILE="$log_dir/setup-$(date +%Y%m%d-%H%M%S).log"
    
    # Redirect stdout and stderr to log file while also displaying
    exec > >(tee -a "$LOG_FILE")
    exec 2> >(tee -a "$LOG_FILE" >&2)
    
    print_info "Logging to: $LOG_FILE"
}

# =======================================
# Core Installation Functions
# =======================================
install_xcode_tools() {
    if [ "$INSTALL_XCODE_TOOLS" = "true" ]; then
        if ! xcode-select -p &> /dev/null; then
            print_step "Installing Xcode Command Line Tools..."
            xcode-select --install
            
            print_warning "Please complete the Xcode Command Line Tools installation"
            print_info "Press Enter when installation is complete..."
            read -r
        else
            print_success "Xcode Command Line Tools already installed"
        fi
    fi
}

install_homebrew() {
    if [ "$INSTALL_HOMEBREW" = "true" ]; then
        if ! command -v brew &> /dev/null; then
            print_step "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            
            # Add Homebrew to PATH for Apple Silicon Macs
            if [[ -f "/opt/homebrew/bin/brew" ]]; then
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
            print_success "Homebrew installed"
        else
            print_success "Homebrew already installed"
        fi
        
        # Update Homebrew
        print_step "Updating Homebrew..."
        brew update
        
        # Install Homebrew Cask if needed
        if [ "$INSTALL_HOMEBREW_CASK" = "true" ]; then
            print_step "Setting up Homebrew Cask..."
            # Cask is built into modern Homebrew
            print_success "Homebrew Cask ready"
        fi
    fi
}

install_oh_my_zsh() {
    if [ "$INSTALL_OH_MY_ZSH" = "true" ]; then
        if [ ! -d "$HOME/.oh-my-zsh" ]; then
            print_step "Installing Oh My Zsh..."
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
            print_success "Oh My Zsh installed"
        else
            print_success "Oh My Zsh already installed"
        fi
    fi
}

install_powerlevel10k() {
    if [ "$INSTALL_POWERLEVEL10K" = "true" ]; then
        local p10k_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
        if [ ! -d "$p10k_dir" ]; then
            print_step "Installing Powerlevel10k theme..."
            git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
            print_success "Powerlevel10k installed"
        else
            print_success "Powerlevel10k already installed"
        fi
    fi
}

install_zsh_plugins() {
    if [ "$INSTALL_ZSH_PLUGINS" = "true" ]; then
        print_step "Installing ZSH plugins..."
        
        local plugins=(
            "zsh-autosuggestions"
            "zsh-syntax-highlighting"
            "zsh-completions"
        )
        
        for plugin in "${plugins[@]}"; do
            if ! brew list "$plugin" &> /dev/null; then
                print_step "Installing $plugin..."
                brew install "$plugin"
            else
                print_success "$plugin already installed"
            fi
        done
    fi
}

configure_git() {
    if [ "$SETUP_GIT_CONFIG" = "true" ]; then
        print_step "Configuring Git..."
        
        if [ -n "$GIT_USER_NAME" ] && [ "$GIT_USER_NAME" != "Your Name" ]; then
            git config --global user.name "$GIT_USER_NAME"
        fi
        
        if [ -n "$GIT_USER_EMAIL" ] && [ "$GIT_USER_EMAIL" != "your.email@example.com" ]; then
            git config --global user.email "$GIT_USER_EMAIL"
        fi
        
        # Set up useful Git configurations
        git config --global init.defaultBranch main
        git config --global pull.rebase true
        git config --global core.editor "code --wait"
        git config --global diff.tool vscode
        git config --global difftool.vscode.cmd 'code --wait --diff $LOCAL $REMOTE'
        git config --global merge.tool vscode
        git config --global mergetool.vscode.cmd 'code --wait $MERGED'
        
        print_success "Git configured"
    fi
}

configure_macos_defaults() {
    if [ "$CONFIGURE_MACOS_DEFAULTS" = "true" ]; then
        print_step "Configuring macOS defaults..."
        
        # Dock settings
        if [ "$DOCK_AUTOHIDE" = "true" ]; then
            defaults write com.apple.dock autohide -bool true
        fi
        
        # Finder settings
        if [ "$FINDER_SHOW_HIDDEN" = "true" ]; then
            defaults write com.apple.finder AppleShowAllFiles -bool true
        fi
        
        # Screenshot location
        if [ -n "$SCREENSHOTS_LOCATION" ]; then
            mkdir -p "$SCREENSHOTS_LOCATION"
            defaults write com.apple.screencapture location "$SCREENSHOTS_LOCATION"
        fi
        
        # Key repeat settings
        defaults write NSGlobalDomain KeyRepeat -int 1
        defaults write NSGlobalDomain InitialKeyRepeat -int 10
        
        # Show all filename extensions
        defaults write NSGlobalDomain AppleShowAllExtensions -bool true
        
        # Disable the "Are you sure you want to open this application?" dialog
        defaults write com.apple.LaunchServices LSQuarantine -bool false
        
        # Restart affected applications
        killall Dock 2>/dev/null || true
        killall Finder 2>/dev/null || true
        
        print_success "macOS defaults configured"
    fi
}

setup_ssh_keys() {
    if [ "$SETUP_SSH_KEYS" = "true" ]; then
        if [ ! -f "$HOME/.ssh/id_ed25519" ] && [ ! -f "$HOME/.ssh/id_rsa" ]; then
            print_step "Setting up SSH keys..."
            
            echo "Would you like to generate SSH keys?"
            echo "This will create a new Ed25519 key pair for secure connections."
            read -p "Generate SSH keys? [y/N]: " -n 1 -r
            echo
            
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                read -p "Enter your email for the SSH key: " ssh_email
                ssh-keygen -t ed25519 -C "$ssh_email" -f "$HOME/.ssh/id_ed25519"
                
                # Start SSH agent and add key
                eval "$(ssh-agent -s)"
                ssh-add "$HOME/.ssh/id_ed25519"
                
                # Copy public key to clipboard
                pbcopy < "$HOME/.ssh/id_ed25519.pub"
                
                print_success "SSH key generated and copied to clipboard"
                print_info "Add this key to your GitHub/GitLab account"
            fi
        else
            print_success "SSH keys already exist"
        fi
    fi
}

create_zshrc() {
    print_step "Creating enhanced .zshrc configuration..."
    
    # Backup existing .zshrc if it exists
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
        print_info "Existing .zshrc backed up"
    fi
    
    # Create new .zshrc with all the enhancements
    cat > "$HOME/.zshrc" << 'ZSHRC_EOF'
# Enhanced Perfect ZSH Configuration
# Generated by Perfect ZSH Setup

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =======================================
# PATH Configuration
# =======================================
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="$PATH:$HOME/.local/bin"

# =======================================
# Oh My Zsh Configuration
# =======================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  git-extras
  docker
  docker-compose
  kubectl
  terraform
  aws
  python
  pip
  node
  npm
  yarn
  golang
  rust
  ruby
  rbenv
  brew
  macos
  vscode
  gh
  fzf
  zoxide
  history
  history-substring-search
  command-not-found
  common-aliases
  sudo
  web-search
  jsontools
  encode64
  urltools
  copypath
  copyfile
  copybuffer
  dirhistory
  extract
  colored-man-pages
  safe-paste
)

source $ZSH/oh-my-zsh.sh

# =======================================
# Environment Variables
# =======================================
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export EDITOR='code'
export VISUAL='code'
export PAGER='less'
export LESS='-R -F -X'

# =======================================
# Version Managers
# =======================================
# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Lazy load NVM for better performance
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# pyenv (Python Version Manager)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# rbenv (Ruby Version Manager)
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# =======================================
# Package Managers
# =======================================
# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Rust
[ -s "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# =======================================
# Modern CLI Tools
# =======================================
# Better defaults
alias ls='eza --icons --group-directories-first'
alias ll='eza -alh --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias lt='eza --tree --icons -a -I ".git|node_modules|.cache|.venv|dist|build"'
alias l='eza -lah --icons --group-directories-first'

alias cat='bat --style=plain --paging=never'
alias less='bat --style=plain'
alias grep='rg'
alias find='fd'

# =======================================
# Development Aliases
# =======================================
# Git
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gl='git log --oneline --graph --decorate'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
alias gst='git stash'

# Conventional commits
alias gcf='git commit -m "feat: "'
alias gcfx='git commit -m "fix: "'
alias gcd='git commit -m "docs: "'
alias gcs='git commit -m "style: "'
alias gcr='git commit -m "refactor: "'
alias gct='git commit -m "test: "'
alias gcc='git commit -m "chore: "'

# Docker
alias dk='docker'
alias dkc='docker compose'
alias dkps='docker ps'
alias dkpsa='docker ps -a'
alias dki='docker images'

# Package managers
alias n='npm'
alias nr='npm run'
alias ni='npm install'
alias p='pnpm'
alias pr='pnpm run'
alias pi='pnpm install'
alias y='yarn'
alias ya='yarn add'
alias yr='yarn remove'

# Python
alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'

# =======================================
# Productivity Functions
# =======================================
# Create directory and cd into it
mkcd() {
  mkdir -p "$@" && cd "$_"
}

# Find file by name
findf() {
  fd --type f "$1"
}

# Find directory by name
findd() {
  fd --type d "$1"
}

# Project info
project-info() {
  echo "=== Project Analysis ==="
  echo "Directory: $(pwd)"
  
  if [ -f "package.json" ]; then
    echo "Type: Node.js/JavaScript"
    if [ -f "pnpm-lock.yaml" ]; then
      echo "Package Manager: pnpm"
    elif [ -f "yarn.lock" ]; then
      echo "Package Manager: yarn"
    else
      echo "Package Manager: npm"
    fi
    
    echo -e "\nAvailable scripts:"
    jq -r '.scripts | to_entries[] | "  \(.key): \(.value)"' package.json 2>/dev/null | head -10
    
    [ -f "tsconfig.json" ] && echo -e "\n✓ TypeScript configured"
  fi
  
  [ -f "Cargo.toml" ] && echo "Type: Rust"
  [ -f "go.mod" ] && echo "Type: Go"
  [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] && echo "Type: Python"
  
  echo -e "\nDevelopment setup:"
  [ -f "docker-compose.yml" ] && echo "  ✓ Docker Compose"
  [ -f ".env.example" ] && echo "  ✓ Environment template"
  [ -f "biome.json" ] && echo "  ✓ Biome formatter"
  [ -d ".github/workflows" ] && echo "  ✓ GitHub Actions"
}

# Install dependencies smartly
install-deps() {
  if [ -f "pnpm-lock.yaml" ]; then
    pnpm install
  elif [ -f "yarn.lock" ]; then
    yarn install
  elif [ -f "package-lock.json" ]; then
    npm ci
  elif [ -f "package.json" ]; then
    pnpm install
  elif [ -f "requirements.txt" ]; then
    pip install -r requirements.txt
  elif [ -f "Cargo.toml" ]; then
    cargo build
  elif [ -f "go.mod" ]; then
    go mod download
  else
    echo "No recognized dependency file found"
  fi
}

# Run dev server intelligently
devrun() {
  if [ -f "package.json" ]; then
    if jq -e '.scripts.dev' package.json > /dev/null; then
      pnpm dev || npm run dev
    elif jq -e '.scripts.start' package.json > /dev/null; then
      pnpm start || npm start
    else
      echo "No dev script found"
    fi
  elif [ -f "Cargo.toml" ]; then
    cargo run
  elif [ -f "main.go" ]; then
    go run .
  elif [ -f "manage.py" ]; then
    python manage.py runserver
  else
    echo "No recognized dev command"
  fi
}

# =======================================
# FZF Configuration
# =======================================
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --inline-info
  --preview "bat --style=numbers --color=always --line-range :500 {}"
  --preview-window=right:60%:wrap
'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# =======================================
# Tool Configurations
# =======================================
# Bat
export BAT_THEME="TwoDark"

# Zoxide
eval "$(zoxide init zsh)"

# Direnv
eval "$(direnv hook zsh)"

# =======================================
# Plugin Configurations
# =======================================
# ZSH Autosuggestions
if [ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi

# ZSH Syntax Highlighting
if [ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# =======================================
# Final Setup
# =======================================
# Remove duplicate PATH entries
typeset -U PATH

# Load Powerlevel10k configuration
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Load local configurations
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
ZSHRC_EOF

    print_success "Enhanced .zshrc created"
}

# =======================================
# Main Installation Flow
# =======================================
run_installation() {
    print_banner
    
    print_step "Starting Perfect ZSH Setup..."
    print_info "Configuration: $CONFIG_FILE"
    print_info "Log file: $LOG_FILE"
    
    # Core system setup
    check_macos
    setup_logging
    install_xcode_tools
    install_homebrew
    
    # Shell setup
    install_oh_my_zsh
    install_powerlevel10k
    install_zsh_plugins
    
    # Load and source installers
    source "$LIB_DIR/installers.sh"
    
    # Version managers
    install_nvm
    install_pyenv
    install_rbenv
    
    # Applications and tools
    install_editors
    install_browsers
    install_productivity_apps
    install_design_tools
    install_communication_apps
    install_developer_utilities
    install_modern_cli_tools
    install_package_managers
    install_cloud_tools
    install_databases
    install_docker
    install_fonts
    install_media_apps
    install_system_utilities
    
    # Configuration
    configure_git
    configure_macos_defaults
    setup_ssh_keys
    create_zshrc
    
    print_success "Installation complete! 🎉"
    show_completion_message
}

show_completion_message() {
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                    Setup Complete!                          ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "🎯 Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Configure Powerlevel10k: p10k configure"
    echo "  3. Set your terminal font to a Nerd Font (e.g., MesloLGS NF)"
    echo ""
    echo "🚀 Useful commands to try:"
    echo "  - project-info    : Analyze current project"
    echo "  - install-deps    : Smart dependency installation"
    echo "  - devrun          : Run development server"
    echo "  - pf              : Interactive file finder"
    echo "  - z <partial>     : Jump to directories"
    echo ""
    echo "📝 Configuration files:"
    echo "  - ~/.zshrc        : Main ZSH configuration"
    echo "  - ~/.p10k.zsh     : Powerlevel10k theme settings"
    echo "  - $CONFIG_FILE    : Setup configuration"
    echo ""
    echo "📋 Log file: $LOG_FILE"
    echo ""
    print_success "Enjoy your perfect development environment!"
}

# =======================================
# Script Entry Point
# =======================================
main() {
    # Check for command line arguments
    case "${1:-}" in
        --config|-c)
            source "$LIB_DIR/interactive.sh"
            show_setup_menu
            if [ $? -eq 0 ]; then
                load_config
                run_installation
            fi
            ;;
        --quick|-q)
            print_info "Running quick setup with default configuration..."
            check_dependencies
            load_config
            run_installation
            ;;
        --help|-h)
            echo "Perfect ZSH Setup - Enhanced Interactive Installation"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -c, --config    Interactive configuration"
            echo "  -q, --quick     Quick setup with defaults"
            echo "  -h, --help      Show this help message"
            echo ""
            echo "Configuration file: $CONFIG_FILE"
            ;;
        *)
            # Default behavior - show interactive menu
            check_dependencies
            source "$LIB_DIR/interactive.sh"
            show_setup_menu
            if [ $? -eq 0 ]; then
                load_config
                run_installation
            fi
            ;;
    esac
}

# Run the main function with all arguments
main "$@"
ZSHRC_EOF

    print_success "Enhanced setup script created"
}

# Make the script executable
chmod +x setup-enhanced.sh

print_success "Enhanced setup script is ready!"