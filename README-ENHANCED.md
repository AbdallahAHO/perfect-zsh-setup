# Perfect ZSH Setup - Enhanced Interactive Edition

🚀 **The ultimate macOS development environment setup with full customization and modern web development tools.**

## ✨ What's New in Enhanced Edition

- **🔧 Interactive Configuration**: Step-by-step customization wizard
- **📦 Complete App Management**: VS Code, Cursor, browsers, productivity apps
- **🐍 Full Version Manager Support**: NVM, pyenv, rbenv with multiple versions
- **⚡ Smart Presets**: Web developer, minimal, and full-stack configurations
- **🛠️ Modular Architecture**: Easy to extend and customize
- **📊 Comprehensive Logging**: Track installation progress and debug issues

## 🚀 Quick Start

### One-Command Setup
```bash
# Interactive setup with full customization
./setup-enhanced.sh --config

# Quick setup with sensible defaults
./setup-enhanced.sh --quick
```

### What Gets Installed

#### 🔧 Version Managers
- **NVM** - Node.js version management (18, 20, 21)
- **pyenv** - Python version management (3.11, 3.12)
- **rbenv** - Ruby version management (3.2.0, 3.3.0)

#### 💻 Editors & IDEs
- **Visual Studio Code** - Popular code editor
- **Cursor** - AI-powered editor
- **Neovim** - Modern vim
- **Sublime Text** *(optional)*
- **IntelliJ IDEA** *(optional)*

#### 🌐 Browsers
- **Google Chrome** - Primary development browser
- **Firefox** - Secondary browser with dev tools
- **Arc** - Modern productivity browser
- **Brave** *(optional)*
- **Safari Technology Preview** *(optional)*

#### 📦 Package Managers
- **pnpm** - Fast, efficient package manager
- **Yarn** - Alternative JavaScript package manager
- **Bun** - Ultra-fast JavaScript runtime
- **Cargo** - Rust package manager
- **Go** - Go programming language

#### 🛠️ Development Tools
- **Docker Desktop** - Containerization platform
- **Postman** - API development and testing
- **TablePlus** - Database management
- **Fork** - Git client with visual interface
- **iTerm2** - Enhanced terminal

#### ⚡ Productivity Apps
- **Raycast** - Powerful Spotlight replacement
- **Rectangle** - Window management
- **Slack** - Team communication
- **Discord** - Community communication
- **Zoom** - Video conferencing

#### 🎨 Design Tools
- **Figma** - UI/UX design
- **ImageOptim** - Image compression

#### ☁️ Cloud & DevOps
- **AWS CLI** - Amazon Web Services
- **Terraform** - Infrastructure as code
- **kubectl** - Kubernetes management

#### 🖥️ Terminal Enhancement
- **Oh My Zsh** - ZSH framework
- **Powerlevel10k** - Beautiful prompt theme
- **fzf** - Fuzzy finder
- **bat** - Better cat with syntax highlighting
- **eza** - Modern ls replacement
- **ripgrep** - Fast text search
- **zoxide** - Smart directory jumping

## 🎯 Setup Modes

### 1. Interactive Configuration
```bash
./setup-enhanced.sh --config
```
- **Guided Setup**: Step-by-step customization
- **Smart Defaults**: Sensible choices with override options
- **Real-time Config**: See your choices reflected immediately
- **Category-based**: Organize tools by development area

### 2. Quick Setup
```bash
./setup-enhanced.sh --quick
```
- **Fast Installation**: Uses web-developer preset
- **No Interruptions**: Automated installation process
- **Ideal for**: New Mac setup, CI/CD, repeated installations

### 3. Preset Configurations
Choose from predefined configurations:

#### 🌐 Web Developer (Recommended)
- Modern web development stack
- Node.js, Python, essential tools
- VS Code, Cursor, Chrome, Arc
- Docker, databases, Figma, Slack

#### 📦 Minimal
- Essential tools only
- Node.js 20, Python 3.12
- VS Code, Chrome, basic CLI tools
- Perfect for lightweight setups

#### 🔧 Full Stack
- Complete development environment
- All languages and tools
- Multiple versions of everything
- Cloud tools, all browsers, all editors

## 📁 Configuration Files

### Main Configuration
```bash
config/setup.conf          # Main configuration file
```

### Presets
```bash
config/presets/web-developer.conf  # Web development focus
config/presets/minimal.conf        # Essential tools only
config/presets/fullstack.conf      # Everything included
```

### Custom Presets
Create your own preset by copying and modifying any existing preset:
```bash
cp config/presets/web-developer.conf config/presets/my-setup.conf
# Edit my-setup.conf with your preferences
cp config/presets/my-setup.conf config/setup.conf
./setup-enhanced.sh --quick
```

## 🔧 Advanced Features

### Smart Installation
- **Dependency Detection**: Checks existing installations
- **Conflict Resolution**: Handles version conflicts gracefully
- **Service Management**: Starts databases and services automatically
- **Backup Creation**: Backs up existing configurations

### Version Management
```bash
# Node.js versions (configured in setup.conf)
NODE_VERSIONS="18 20 21"
DEFAULT_NODE_VERSION="20"

# Python versions
PYTHON_VERSIONS="3.11 3.12"
DEFAULT_PYTHON_VERSION="3.12"

# Ruby versions
RUBY_VERSIONS="3.2.0 3.3.0"
DEFAULT_RUBY_VERSION="3.3.0"
```

### macOS Integration
- **System Preferences**: Dock auto-hide, Finder settings
- **Screenshot Location**: Organized screenshot folder
- **Key Repeat**: Faster key repeat rates
- **File Extensions**: Show all extensions

### Development Workflow
- **Git Configuration**: Name, email, editor, diff tools
- **SSH Key Generation**: Ed25519 keys with GitHub integration
- **Shell Enhancements**: Smart aliases, functions, completions

## 🎨 Customization

### Local Overrides
```bash
# Personal customizations (not tracked by git)
~/.zshrc.local              # Additional shell configuration
~/.local/bin/env           # Environment-specific settings
```

### Theme Configuration
```bash
# After installation, configure your prompt
p10k configure
```

### Adding New Tools

1. **Add to Configuration**:
   ```bash
   # In config/setup.conf
   INSTALL_MY_TOOL=true
   ```

2. **Add Installation Function**:
   ```bash
   # In lib/installers.sh
   install_my_tool() {
     if [ "$INSTALL_MY_TOOL" = "true" ]; then
       brew install my-tool
     fi
   }
   ```

3. **Add Interactive Prompt**:
   ```bash
   # In lib/interactive.sh
   if ask_yes_no "Install My Tool?" "y"; then
     update_config "INSTALL_MY_TOOL" "true"
   fi
   ```

## 📊 Logging and Troubleshooting

### Installation Logs
```bash
logs/setup-YYYYMMDD-HHMMSS.log    # Detailed installation log
```

### Common Issues

1. **Homebrew Issues**:
   ```bash
   brew doctor                     # Check Homebrew health
   ```

2. **Permission Issues**:
   ```bash
   sudo chown -R $(whoami) /opt/homebrew
   ```

3. **Path Issues**:
   ```bash
   echo $PATH                      # Check PATH configuration
   source ~/.zshrc                 # Reload configuration
   ```

## 🤝 Contributing

### Adding New Applications
1. Add configuration option to `config/setup.conf`
2. Create installation function in `lib/installers.sh`
3. Add interactive prompt in `lib/interactive.sh`
4. Test with different preset configurations

### Creating New Presets
1. Copy existing preset: `cp config/presets/web-developer.conf config/presets/my-preset.conf`
2. Modify settings for your use case
3. Test the preset: `cp config/presets/my-preset.conf config/setup.conf && ./setup-enhanced.sh --quick`
4. Submit pull request with documentation

## 📋 System Requirements

- **macOS** 10.15 (Catalina) or later
- **Admin Access** for Homebrew installation
- **Internet Connection** for downloading tools
- **50GB+ Free Space** for full installation

## 🆘 Support

### Quick Help
```bash
./setup-enhanced.sh --help        # Show help and options
```

### Common Commands
```bash
# Restart terminal after installation
source ~/.zshrc

# Configure Powerlevel10k theme
p10k configure

# Check tool versions
nvm --version
python --version
git --version

# Update everything
brew update && brew upgrade
```

---

**Perfect ZSH Setup Enhanced Edition** - Transform your Mac into the ultimate development machine with zero hassle. 🚀