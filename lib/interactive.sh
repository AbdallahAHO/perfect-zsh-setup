#!/bin/bash
# Interactive configuration for Perfect ZSH Setup

# =======================================
# Interactive Configuration Functions
# =======================================

ask_yes_no() {
    local question="$1"
    local default="${2:-n}"
    local response
    
    if [ "$default" = "y" ]; then
        question="$question [Y/n]"
    else
        question="$question [y/N]"
    fi
    
    while true; do
        read -p "$question: " response
        response=${response,,} # Convert to lowercase
        
        if [[ -z "$response" ]]; then
            response="$default"
        fi
        
        case "$response" in
            y|yes) return 0 ;;
            n|no) return 1 ;;
            *) echo "Please answer yes or no." ;;
        esac
    done
}

ask_multiple_choice() {
    local question="$1"
    shift
    local options=("$@")
    local i=1
    
    echo "$question"
    for option in "${options[@]}"; do
        echo "  $i) $option"
        ((i++))
    done
    
    while true; do
        read -p "Choose an option (1-${#options[@]}): " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
            echo "${options[$((choice-1))]}"
            return
        else
            echo "Please enter a valid option number."
        fi
    done
}

ask_input() {
    local question="$1"
    local default="$2"
    local response
    
    if [ -n "$default" ]; then
        question="$question [$default]"
    fi
    
    read -p "$question: " response
    echo "${response:-$default}"
}

setup_interactive_config() {
    clear
    echo "🚀 Perfect ZSH Setup - Interactive Configuration"
    echo "================================================"
    echo ""
    echo "This script will help you customize your development environment."
    echo "You can always edit config/setup.conf later to make changes."
    echo ""
    
    # Create config file
    local config_file="config/setup.conf"
    cp "$config_file" "${config_file}.backup"
    
    # Basic setup questions
    echo "📋 Basic Setup"
    echo "---------------"
    
    if ask_yes_no "Install Oh My Zsh and Powerlevel10k theme?" "y"; then
        update_config "INSTALL_OH_MY_ZSH" "true"
        update_config "INSTALL_POWERLEVEL10K" "true"
    else
        update_config "INSTALL_OH_MY_ZSH" "false"
        update_config "INSTALL_POWERLEVEL10K" "false"
    fi
    
    # Version managers
    echo ""
    echo "🔧 Version Managers"
    echo "-------------------"
    
    if ask_yes_no "Install Node Version Manager (NVM)?" "y"; then
        update_config "INSTALL_NVM" "true"
        
        echo "Which Node.js versions would you like to install?"
        echo "Popular choices: 16 (LTS), 18 (LTS), 20 (LTS), 21 (Current)"
        node_versions=$(ask_input "Enter versions separated by spaces" "18 20 21")
        update_config "NODE_VERSIONS" "\"$node_versions\""
        
        default_node=$(ask_input "Default Node.js version" "20")
        update_config "DEFAULT_NODE_VERSION" "\"$default_node\""
    else
        update_config "INSTALL_NVM" "false"
    fi
    
    if ask_yes_no "Install Python Version Manager (pyenv)?" "y"; then
        update_config "INSTALL_PYENV" "true"
        
        python_versions=$(ask_input "Python versions to install (space-separated)" "3.11 3.12")
        update_config "PYTHON_VERSIONS" "\"$python_versions\""
        
        default_python=$(ask_input "Default Python version" "3.12")
        update_config "DEFAULT_PYTHON_VERSION" "\"$default_python\""
    else
        update_config "INSTALL_PYENV" "false"
    fi
    
    if ask_yes_no "Install Ruby Version Manager (rbenv)?" "y"; then
        update_config "INSTALL_RBENV" "true"
        
        ruby_versions=$(ask_input "Ruby versions to install (space-separated)" "3.2.0 3.3.0")
        update_config "RUBY_VERSIONS" "\"$ruby_versions\""
        
        default_ruby=$(ask_input "Default Ruby version" "3.3.0")
        update_config "DEFAULT_RUBY_VERSION" "\"$default_ruby\""
    else
        update_config "INSTALL_RBENV" "false"
    fi
    
    # Editors and IDEs
    echo ""
    echo "💻 Editors & IDEs"
    echo "-----------------"
    
    if ask_yes_no "Install Visual Studio Code?" "y"; then
        update_config "INSTALL_VSCODE" "true"
    fi
    
    if ask_yes_no "Install Cursor (AI-powered editor)?" "y"; then
        update_config "INSTALL_CURSOR" "true"
    fi
    
    if ask_yes_no "Install Neovim?" "y"; then
        update_config "INSTALL_NEOVIM" "true"
    fi
    
    if ask_yes_no "Install Sublime Text?" "n"; then
        update_config "INSTALL_SUBLIME" "true"
    fi
    
    if ask_yes_no "Install IntelliJ IDEA?" "n"; then
        update_config "INSTALL_INTELLIJ" "true"
    fi
    
    # Browsers
    echo ""
    echo "🌐 Browsers"
    echo "-----------"
    
    if ask_yes_no "Install Google Chrome?" "y"; then
        update_config "INSTALL_CHROME" "true"
    fi
    
    if ask_yes_no "Install Firefox?" "y"; then
        update_config "INSTALL_FIREFOX" "true"
    fi
    
    if ask_yes_no "Install Arc Browser?" "y"; then
        update_config "INSTALL_ARC" "true"
    fi
    
    if ask_yes_no "Install Brave Browser?" "n"; then
        update_config "INSTALL_BRAVE" "true"
    fi
    
    # Development tools
    echo ""
    echo "🛠️  Development Tools"
    echo "--------------------"
    
    if ask_yes_no "Install Docker Desktop?" "y"; then
        update_config "INSTALL_DOCKER" "true"
    fi
    
    if ask_yes_no "Install databases (PostgreSQL, MySQL, Redis, MongoDB)?" "y"; then
        update_config "INSTALL_DATABASES" "true"
    fi
    
    if ask_yes_no "Install Postman (API testing)?" "y"; then
        update_config "INSTALL_POSTMAN" "true"
    fi
    
    if ask_yes_no "Install TablePlus (database client)?" "y"; then
        update_config "INSTALL_TABLEPLUS" "true"
    fi
    
    if ask_yes_no "Install Fork (Git client)?" "y"; then
        update_config "INSTALL_FORK" "true"
    fi
    
    # Terminal
    echo ""
    echo "💾 Terminal & CLI Tools"
    echo "----------------------"
    
    if ask_yes_no "Install iTerm2?" "y"; then
        update_config "INSTALL_ITERM2" "true"
    fi
    
    if ask_yes_no "Install modern CLI tools (fzf, bat, eza, ripgrep, etc.)?" "y"; then
        update_config "INSTALL_MODERN_CLI" "true"
        update_config "INSTALL_FZF" "true"
        update_config "INSTALL_BAT" "true"
        update_config "INSTALL_EZA" "true"
        update_config "INSTALL_RIPGREP" "true"
        update_config "INSTALL_FD" "true"
        update_config "INSTALL_DELTA" "true"
        update_config "INSTALL_ZOXIDE" "true"
    fi
    
    # Package managers
    echo ""
    echo "📦 Package Managers"
    echo "-------------------"
    
    if ask_yes_no "Install pnpm (fast package manager)?" "y"; then
        update_config "INSTALL_PNPM" "true"
    fi
    
    if ask_yes_no "Install Yarn?" "y"; then
        update_config "INSTALL_YARN" "true"
    fi
    
    if ask_yes_no "Install Bun (fast JavaScript runtime)?" "y"; then
        update_config "INSTALL_BUN" "true"
    fi
    
    if ask_yes_no "Install Go programming language?" "y"; then
        update_config "INSTALL_GO" "true"
    fi
    
    if ask_yes_no "Install Rust programming language?" "y"; then
        update_config "INSTALL_CARGO" "true"
    fi
    
    # Productivity apps
    echo ""
    echo "⚡ Productivity Apps"
    echo "-------------------"
    
    if ask_yes_no "Install Raycast (Spotlight replacement)?" "y"; then
        update_config "INSTALL_RAYCAST" "true"
    fi
    
    if ask_yes_no "Install Rectangle (window management)?" "y"; then
        update_config "INSTALL_RECTANGLE" "true"
    fi
    
    # Design tools
    echo ""
    echo "🎨 Design Tools"
    echo "---------------"
    
    if ask_yes_no "Install Figma?" "y"; then
        update_config "INSTALL_FIGMA" "true"
    fi
    
    if ask_yes_no "Install ImageOptim (image optimization)?" "y"; then
        update_config "INSTALL_IMAGEOPTIM" "true"
    fi
    
    # Communication
    echo ""
    echo "💬 Communication"
    echo "----------------"
    
    if ask_yes_no "Install Slack?" "y"; then
        update_config "INSTALL_SLACK" "true"
    fi
    
    if ask_yes_no "Install Discord?" "y"; then
        update_config "INSTALL_DISCORD" "true"
    fi
    
    if ask_yes_no "Install Zoom?" "y"; then
        update_config "INSTALL_ZOOM" "true"
    fi
    
    # Media
    echo ""
    echo "🎵 Media & Entertainment"
    echo "-----------------------"
    
    if ask_yes_no "Install Spotify?" "y"; then
        update_config "INSTALL_SPOTIFY" "true"
    fi
    
    if ask_yes_no "Install VLC Media Player?" "y"; then
        update_config "INSTALL_VLC" "true"
    fi
    
    # Cloud tools
    echo ""
    echo "☁️  Cloud Tools"
    echo "--------------"
    
    if ask_yes_no "Install AWS CLI?" "n"; then
        update_config "INSTALL_AWS_CLI" "true"
    fi
    
    if ask_yes_no "Install Terraform?" "n"; then
        update_config "INSTALL_TERRAFORM" "true"
    fi
    
    if ask_yes_no "Install kubectl (Kubernetes CLI)?" "n"; then
        update_config "INSTALL_KUBECTL" "true"
    fi
    
    # Git configuration
    echo ""
    echo "🔧 Git Configuration"
    echo "--------------------"
    
    if ask_yes_no "Configure Git user information?" "y"; then
        update_config "SETUP_GIT_CONFIG" "true"
        
        git_name=$(ask_input "Your full name" "")
        update_config "GIT_USER_NAME" "\"$git_name\""
        
        git_email=$(ask_input "Your email address" "")
        update_config "GIT_USER_EMAIL" "\"$git_email\""
    fi
    
    # macOS settings
    echo ""
    echo "🖥️  macOS Configuration"
    echo "----------------------"
    
    if ask_yes_no "Configure macOS system defaults?" "y"; then
        update_config "CONFIGURE_MACOS_DEFAULTS" "true"
        
        if ask_yes_no "Auto-hide the Dock?" "y"; then
            update_config "DOCK_AUTOHIDE" "true"
        fi
        
        if ask_yes_no "Show hidden files in Finder?" "y"; then
            update_config "FINDER_SHOW_HIDDEN" "true"
        fi
        
        screenshots_location=$(ask_input "Screenshots location" "~/Desktop/Screenshots")
        update_config "SCREENSHOTS_LOCATION" "\"$screenshots_location\""
    fi
    
    # Final options
    echo ""
    echo "🚀 Final Options"
    echo "---------------"
    
    if ask_yes_no "Skip confirmation prompts during installation?" "n"; then
        update_config "SKIP_CONFIRMATIONS" "true"
    fi
    
    if ask_yes_no "Enable verbose output?" "y"; then
        update_config "VERBOSE_OUTPUT" "true"
    fi
    
    echo ""
    echo "✅ Configuration complete!"
    echo "Your settings have been saved to $config_file"
    echo ""
    echo "Ready to run the installation? The process will:"
    echo "• Install Homebrew and essential tools"
    echo "• Set up your shell environment"
    echo "• Install selected applications"
    echo "• Configure development tools"
    echo ""
    
    if ask_yes_no "Start installation now?" "y"; then
        return 0
    else
        echo "Configuration saved. Run './setup.sh' when you're ready to install."
        return 1
    fi
}

update_config() {
    local key="$1"
    local value="$2"
    local config_file="config/setup.conf"
    
    # Use sed to update the configuration file
    if grep -q "^$key=" "$config_file"; then
        sed -i "" "s/^$key=.*/$key=$value/" "$config_file"
    else
        echo "$key=$value" >> "$config_file"
    fi
}

show_setup_menu() {
    clear
    echo "🚀 Perfect ZSH Setup"
    echo "===================="
    echo ""
    echo "Choose your setup method:"
    echo ""
    echo "1) 🎯 Quick Setup (Recommended defaults)"
    echo "2) 🔧 Interactive Setup (Customize everything)"
    echo "3) 📝 Edit Configuration File"
    echo "4) 📖 Show Current Configuration"
    echo "5) 🚪 Exit"
    echo ""
    
    while true; do
        read -p "Choose an option (1-5): " choice
        case $choice in
            1)
                echo "Starting quick setup with recommended defaults..."
                return 0
                ;;
            2)
                setup_interactive_config
                return $?
                ;;
            3)
                ${EDITOR:-nano} config/setup.conf
                echo "Configuration file updated. Returning to menu..."
                show_setup_menu
                return $?
                ;;
            4)
                show_current_config
                echo ""
                read -p "Press Enter to return to menu..."
                show_setup_menu
                return $?
                ;;
            5)
                echo "Setup cancelled."
                exit 0
                ;;
            *)
                echo "Please enter a valid option (1-5)."
                ;;
        esac
    done
}

show_current_config() {
    local config_file="config/setup.conf"
    
    echo "📋 Current Configuration"
    echo "========================"
    echo ""
    
    # Parse and display key settings
    echo "🔧 Version Managers:"
    grep -E "^INSTALL_(NVM|PYENV|RBENV)=" "$config_file" | sed 's/INSTALL_/  - /' | sed 's/=/ = /'
    
    echo ""
    echo "💻 Editors & IDEs:"
    grep -E "^INSTALL_(VSCODE|CURSOR|NEOVIM|SUBLIME|INTELLIJ)=" "$config_file" | sed 's/INSTALL_/  - /' | sed 's/=/ = /'
    
    echo ""
    echo "🌐 Browsers:"
    grep -E "^INSTALL_(CHROME|FIREFOX|ARC|BRAVE|SAFARI)=" "$config_file" | sed 's/INSTALL_/  - /' | sed 's/=/ = /'
    
    echo ""
    echo "🛠️  Development Tools:"
    grep -E "^INSTALL_(DOCKER|DATABASES|POSTMAN|TABLEPLUS|FORK)=" "$config_file" | sed 's/INSTALL_/  - /' | sed 's/=/ = /'
    
    echo ""
    echo "📦 Package Managers:"
    grep -E "^INSTALL_(PNPM|YARN|BUN|GO|CARGO)=" "$config_file" | sed 's/INSTALL_/  - /' | sed 's/=/ = /'
    
    echo ""
    echo "⚡ Productivity & Communication:"
    grep -E "^INSTALL_(RAYCAST|RECTANGLE|SLACK|DISCORD|ZOOM|SPOTIFY)=" "$config_file" | sed 's/INSTALL_/  - /' | sed 's/=/ = /'
}

# Function to create preset configurations
create_preset_configs() {
    # Full Web Developer preset
    cat > config/presets/web-developer.conf << 'EOF'
# Web Developer Preset - Everything you need for modern web development
INSTALL_NVM=true
NODE_VERSIONS="18 20 21"
DEFAULT_NODE_VERSION="20"
INSTALL_PYENV=true
PYTHON_VERSIONS="3.11 3.12"
DEFAULT_PYTHON_VERSION="3.12"
INSTALL_RBENV=false

INSTALL_VSCODE=true
INSTALL_CURSOR=true
INSTALL_NEOVIM=true

INSTALL_CHROME=true
INSTALL_FIREFOX=true
INSTALL_ARC=true

INSTALL_DOCKER=true
INSTALL_DATABASES=true
INSTALL_POSTMAN=true
INSTALL_TABLEPLUS=true
INSTALL_FORK=true

INSTALL_PNPM=true
INSTALL_YARN=true
INSTALL_BUN=true

INSTALL_MODERN_CLI=true
INSTALL_RAYCAST=true
INSTALL_RECTANGLE=true
INSTALL_FIGMA=true

INSTALL_SLACK=true
INSTALL_DISCORD=true
INSTALL_SPOTIFY=true
EOF

    # Minimal Developer preset
    cat > config/presets/minimal.conf << 'EOF'
# Minimal Preset - Just the essentials
INSTALL_NVM=true
NODE_VERSIONS="20"
DEFAULT_NODE_VERSION="20"
INSTALL_PYENV=true
PYTHON_VERSIONS="3.12"
DEFAULT_PYTHON_VERSION="3.12"

INSTALL_VSCODE=true
INSTALL_CHROME=true
INSTALL_MODERN_CLI=true
INSTALL_PNPM=true

# Disable most optional tools
INSTALL_CURSOR=false
INSTALL_DOCKER=false
INSTALL_DATABASES=false
EOF

    # Full Stack preset
    cat > config/presets/fullstack.conf << 'EOF'
# Full Stack Preset - Backend, frontend, and everything in between
INSTALL_NVM=true
INSTALL_PYENV=true
INSTALL_RBENV=true
INSTALL_GO=true
INSTALL_CARGO=true

INSTALL_VSCODE=true
INSTALL_CURSOR=true

INSTALL_DOCKER=true
INSTALL_DATABASES=true
INSTALL_AWS_CLI=true
INSTALL_TERRAFORM=true
INSTALL_KUBECTL=true

INSTALL_POSTMAN=true
INSTALL_TABLEPLUS=true
EOF
}