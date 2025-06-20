#!/bin/bash
# Modular installation functions for Perfect ZSH Setup

# =======================================
# Version Managers
# =======================================
install_nvm() {
    if [ "$INSTALL_NVM" = "true" ]; then
        if [ ! -d "$HOME/.nvm" ]; then
            print_step "Installing NVM..."
            curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash
            export NVM_DIR="$HOME/.nvm"
            [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
            
            # Install Node versions
            if [ -n "$NODE_VERSIONS" ]; then
                for version in $NODE_VERSIONS; do
                    print_step "Installing Node.js $version..."
                    nvm install $version
                done
                
                # Set default version
                if [ -n "$DEFAULT_NODE_VERSION" ]; then
                    print_step "Setting Node.js $DEFAULT_NODE_VERSION as default..."
                    nvm alias default $DEFAULT_NODE_VERSION
                    nvm use default
                fi
            fi
            print_success "NVM installed and configured"
        else
            print_success "NVM already installed"
        fi
    fi
}

install_pyenv() {
    if [ "$INSTALL_PYENV" = "true" ]; then
        if ! command -v pyenv &> /dev/null; then
            print_step "Installing pyenv..."
            brew install pyenv pyenv-virtualenv
            
            # Install Python versions
            if [ -n "$PYTHON_VERSIONS" ]; then
                for version in $PYTHON_VERSIONS; do
                    print_step "Installing Python $version..."
                    pyenv install $version
                done
                
                # Set default version
                if [ -n "$DEFAULT_PYTHON_VERSION" ]; then
                    print_step "Setting Python $DEFAULT_PYTHON_VERSION as global default..."
                    pyenv global $DEFAULT_PYTHON_VERSION
                fi
            fi
            print_success "pyenv installed and configured"
        else
            print_success "pyenv already installed"
        fi
    fi
}

install_rbenv() {
    if [ "$INSTALL_RBENV" = "true" ]; then
        if ! command -v rbenv &> /dev/null; then
            print_step "Installing rbenv..."
            brew install rbenv ruby-build
            
            # Install Ruby versions
            if [ -n "$RUBY_VERSIONS" ]; then
                for version in $RUBY_VERSIONS; do
                    print_step "Installing Ruby $version..."
                    rbenv install $version
                done
                
                # Set default version
                if [ -n "$DEFAULT_RUBY_VERSION" ]; then
                    print_step "Setting Ruby $DEFAULT_RUBY_VERSION as global default..."
                    rbenv global $DEFAULT_RUBY_VERSION
                fi
            fi
            print_success "rbenv installed and configured"
        else
            print_success "rbenv already installed"
        fi
    fi
}

# =======================================
# Editors & IDEs
# =======================================
install_editors() {
    local editors=()
    
    [ "$INSTALL_VSCODE" = "true" ] && editors+=("visual-studio-code")
    [ "$INSTALL_CURSOR" = "true" ] && editors+=("cursor")
    [ "$INSTALL_SUBLIME" = "true" ] && editors+=("sublime-text")
    [ "$INSTALL_INTELLIJ" = "true" ] && editors+=("intellij-idea")
    
    if [ ${#editors[@]} -gt 0 ]; then
        print_step "Installing editors and IDEs..."
        for editor in "${editors[@]}"; do
            if ! brew list --cask "$editor" &> /dev/null; then
                print_step "Installing $editor..."
                brew install --cask "$editor"
            else
                print_success "$editor already installed"
            fi
        done
    fi
    
    # Install Neovim separately as it's a formula, not cask
    if [ "$INSTALL_NEOVIM" = "true" ]; then
        if ! brew list neovim &> /dev/null; then
            print_step "Installing Neovim..."
            brew install neovim
        else
            print_success "Neovim already installed"
        fi
    fi
}

# =======================================
# Browsers
# =======================================
install_browsers() {
    local browsers=()
    
    [ "$INSTALL_CHROME" = "true" ] && browsers+=("google-chrome")
    [ "$INSTALL_FIREFOX" = "true" ] && browsers+=("firefox")
    [ "$INSTALL_SAFARI_TECH_PREVIEW" = "true" ] && browsers+=("safari-technology-preview")
    [ "$INSTALL_ARC" = "true" ] && browsers+=("arc")
    [ "$INSTALL_BRAVE" = "true" ] && browsers+=("brave-browser")
    
    if [ ${#browsers[@]} -gt 0 ]; then
        print_step "Installing browsers..."
        for browser in "${browsers[@]}"; do
            if ! brew list --cask "$browser" &> /dev/null; then
                print_step "Installing $browser..."
                brew install --cask "$browser"
            else
                print_success "$browser already installed"
            fi
        done
    fi
}

# =======================================
# Productivity Apps
# =======================================
install_productivity_apps() {
    local apps=()
    
    [ "$INSTALL_RAYCAST" = "true" ] && apps+=("raycast")
    [ "$INSTALL_RECTANGLE" = "true" ] && apps+=("rectangle")
    [ "$INSTALL_BARTENDER" = "true" ] && apps+=("bartender-4")
    [ "$INSTALL_CLEANMYMAC" = "true" ] && apps+=("cleanmymac")
    [ "$INSTALL_LOGI_OPTIONS" = "true" ] && apps+=("logi-options-plus")
    
    if [ ${#apps[@]} -gt 0 ]; then
        print_step "Installing productivity apps..."
        for app in "${apps[@]}"; do
            if ! brew list --cask "$app" &> /dev/null; then
                print_step "Installing $app..."
                brew install --cask "$app"
            else
                print_success "$app already installed"
            fi
        done
    fi
}

# =======================================
# Design Tools
# =======================================
install_design_tools() {
    local tools=()
    
    [ "$INSTALL_FIGMA" = "true" ] && tools+=("figma")
    [ "$INSTALL_SKETCH" = "true" ] && tools+=("sketch")
    [ "$INSTALL_PHOTOSHOP" = "true" ] && tools+=("adobe-creative-cloud")
    [ "$INSTALL_IMAGEOPTIM" = "true" ] && tools+=("imageoptim")
    
    if [ ${#tools[@]} -gt 0 ]; then
        print_step "Installing design tools..."
        for tool in "${tools[@]}"; do
            if ! brew list --cask "$tool" &> /dev/null; then
                print_step "Installing $tool..."
                brew install --cask "$tool"
            else
                print_success "$tool already installed"
            fi
        done
    fi
}

# =======================================
# Communication Apps
# =======================================
install_communication_apps() {
    local apps=()
    
    [ "$INSTALL_SLACK" = "true" ] && apps+=("slack")
    [ "$INSTALL_DISCORD" = "true" ] && apps+=("discord")
    [ "$INSTALL_ZOOM" = "true" ] && apps+=("zoom")
    [ "$INSTALL_TEAMS" = "true" ] && apps+=("microsoft-teams")
    [ "$INSTALL_TELEGRAM" = "true" ] && apps+=("telegram")
    
    if [ ${#apps[@]} -gt 0 ]; then
        print_step "Installing communication apps..."
        for app in "${apps[@]}"; do
            if ! brew list --cask "$app" &> /dev/null; then
                print_step "Installing $app..."
                brew install --cask "$app"
            else
                print_success "$app already installed"
            fi
        done
    fi
}

# =======================================
# Developer Utilities
# =======================================
install_developer_utilities() {
    local utilities=()
    
    [ "$INSTALL_POSTMAN" = "true" ] && utilities+=("postman")
    [ "$INSTALL_INSOMNIA" = "true" ] && utilities+=("insomnia")
    [ "$INSTALL_TABLEPLUS" = "true" ] && utilities+=("tableplus")
    [ "$INSTALL_SEQUEL_PRO" = "true" ] && utilities+=("sequel-pro")
    [ "$INSTALL_SOURCETREE" = "true" ] && utilities+=("sourcetree")
    [ "$INSTALL_FORK" = "true" ] && utilities+=("fork")
    [ "$INSTALL_ITERM2" = "true" ] && utilities+=("iterm2")
    [ "$INSTALL_WARP" = "true" ] && utilities+=("warp")
    
    if [ ${#utilities[@]} -gt 0 ]; then
        print_step "Installing developer utilities..."
        for utility in "${utilities[@]}"; do
            if ! brew list --cask "$utility" &> /dev/null; then
                print_step "Installing $utility..."
                brew install --cask "$utility"
            else
                print_success "$utility already installed"
            fi
        done
    fi
}

# =======================================
# Modern CLI Tools
# =======================================
install_modern_cli_tools() {
    if [ "$INSTALL_MODERN_CLI" = "true" ]; then
        local tools=()
        
        [ "$INSTALL_FZF" = "true" ] && tools+=("fzf")
        [ "$INSTALL_BAT" = "true" ] && tools+=("bat")
        [ "$INSTALL_EZA" = "true" ] && tools+=("eza")
        [ "$INSTALL_RIPGREP" = "true" ] && tools+=("ripgrep")
        [ "$INSTALL_FD" = "true" ] && tools+=("fd")
        [ "$INSTALL_DELTA" = "true" ] && tools+=("git-delta")
        [ "$INSTALL_ZOXIDE" = "true" ] && tools+=("zoxide")
        [ "$INSTALL_TLDR" = "true" ] && tools+=("tldr")
        [ "$INSTALL_JQ" = "true" ] && tools+=("jq")
        [ "$INSTALL_HTOP" = "true" ] && tools+=("htop")
        [ "$INSTALL_TREE" = "true" ] && tools+=("tree")
        
        if [ ${#tools[@]} -gt 0 ]; then
            print_step "Installing modern CLI tools..."
            for tool in "${tools[@]}"; do
                if ! brew list "$tool" &> /dev/null; then
                    print_step "Installing $tool..."
                    brew install "$tool"
                else
                    print_success "$tool already installed"
                fi
            done
        fi
    fi
}

# =======================================
# Package Managers
# =======================================
install_package_managers() {
    # pnpm
    if [ "$INSTALL_PNPM" = "true" ] && ! command -v pnpm &> /dev/null; then
        print_step "Installing pnpm..."
        curl -fsSL https://get.pnpm.io/install.sh | sh -
    fi
    
    # Yarn
    if [ "$INSTALL_YARN" = "true" ] && ! brew list yarn &> /dev/null; then
        print_step "Installing Yarn..."
        brew install yarn
    fi
    
    # Bun
    if [ "$INSTALL_BUN" = "true" ] && ! command -v bun &> /dev/null; then
        print_step "Installing Bun..."
        curl -fsSL https://bun.sh/install | bash
    fi
    
    # Cargo (Rust)
    if [ "$INSTALL_CARGO" = "true" ] && ! command -v cargo &> /dev/null; then
        print_step "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi
    
    # Go
    if [ "$INSTALL_GO" = "true" ] && ! brew list go &> /dev/null; then
        print_step "Installing Go..."
        brew install go
    fi
}

# =======================================
# Cloud Tools
# =======================================
install_cloud_tools() {
    local tools=()
    
    [ "$INSTALL_AWS_CLI" = "true" ] && tools+=("awscli")
    [ "$INSTALL_AZURE_CLI" = "true" ] && tools+=("azure-cli")
    [ "$INSTALL_GCP_CLI" = "true" ] && tools+=("google-cloud-sdk")
    [ "$INSTALL_TERRAFORM" = "true" ] && tools+=("terraform")
    [ "$INSTALL_KUBECTL" = "true" ] && tools+=("kubectl")
    [ "$INSTALL_HELM" = "true" ] && tools+=("helm")
    
    if [ ${#tools[@]} -gt 0 ]; then
        print_step "Installing cloud tools..."
        for tool in "${tools[@]}"; do
            if ! brew list "$tool" &> /dev/null; then
                print_step "Installing $tool..."
                brew install "$tool"
            else
                print_success "$tool already installed"
            fi
        done
    fi
}

# =======================================
# Databases
# =======================================
install_databases() {
    if [ "$INSTALL_DATABASES" = "true" ]; then
        local databases=()
        databases+=("postgresql@15")
        databases+=("mysql")
        databases+=("redis")
        databases+=("mongodb-community")
        
        # Add MongoDB tap
        brew tap mongodb/brew
        
        print_step "Installing databases..."
        for db in "${databases[@]}"; do
            if ! brew list "$db" &> /dev/null; then
                print_step "Installing $db..."
                brew install "$db"
            else
                print_success "$db already installed"
            fi
        done
        
        # Start services
        print_step "Starting database services..."
        brew services start postgresql@15
        brew services start mysql
        brew services start redis
        brew services start mongodb-community
    fi
}

# =======================================
# Docker
# =======================================
install_docker() {
    if [ "$INSTALL_DOCKER" = "true" ]; then
        if ! brew list --cask docker &> /dev/null; then
            print_step "Installing Docker Desktop..."
            brew install --cask docker
            print_success "Docker Desktop installed"
        else
            print_success "Docker Desktop already installed"
        fi
    fi
}

# =======================================
# Fonts
# =======================================
install_fonts() {
    if [ "$INSTALL_NERD_FONTS" = "true" ]; then
        print_step "Installing Nerd Fonts..."
        brew tap homebrew/cask-fonts
        
        local fonts=(
            "font-meslo-lg-nerd-font"
            "font-fira-code-nerd-font"
            "font-hack-nerd-font"
            "font-source-code-pro-nerd-font"
            "font-jetbrains-mono-nerd-font"
        )
        
        for font in "${fonts[@]}"; do
            if ! brew list --cask "$font" &> /dev/null; then
                print_step "Installing $font..."
                brew install --cask "$font"
            else
                print_success "$font already installed"
            fi
        done
    fi
    
    if [ "$INSTALL_GOOGLE_FONTS" = "true" ]; then
        print_step "Installing popular Google Fonts..."
        local google_fonts=(
            "font-inter"
            "font-roboto"
            "font-open-sans"
            "font-lato"
            "font-poppins"
        )
        
        for font in "${google_fonts[@]}"; do
            if ! brew list --cask "$font" &> /dev/null; then
                print_step "Installing $font..."
                brew install --cask "$font"
            else
                print_success "$font already installed"
            fi
        done
    fi
}

# =======================================
# Media Apps
# =======================================
install_media_apps() {
    local apps=()
    
    [ "$INSTALL_SPOTIFY" = "true" ] && apps+=("spotify")
    [ "$INSTALL_VLC" = "true" ] && apps+=("vlc")
    [ "$INSTALL_PLEX" = "true" ] && apps+=("plex")
    [ "$INSTALL_NETFLIX" = "true" ] && apps+=("netflix")
    
    if [ ${#apps[@]} -gt 0 ]; then
        print_step "Installing media apps..."
        for app in "${apps[@]}"; do
            if ! brew list --cask "$app" &> /dev/null; then
                print_step "Installing $app..."
                brew install --cask "$app"
            else
                print_success "$app already installed"
            fi
        done
    fi
}

# =======================================
# System Utilities
# =======================================
install_system_utilities() {
    if [ "$INSTALL_MAS" = "true" ] && ! brew list mas &> /dev/null; then
        print_step "Installing Mac App Store CLI..."
        brew install mas
    fi
    
    if [ "$INSTALL_MACKUP" = "true" ] && ! brew list mackup &> /dev/null; then
        print_step "Installing Mackup..."
        brew install mackup
    fi
    
    if [ "$INSTALL_DUTI" = "true" ] && ! brew list duti &> /dev/null; then
        print_step "Installing duti..."
        brew install duti
    fi
}