# Perfect ZSH Setup for macOS

This guide will set up a fully-featured, modern ZSH environment with autocompletion, syntax highlighting, and productivity tools.

## Features

- 🚀 **Oh My Zsh** with Powerlevel10k theme
- ✨ **Autosuggestions** - See command suggestions as you type
- 🎨 **Syntax Highlighting** - Valid commands in green, errors in red
- 🔍 **FZF Integration** - Fuzzy search for files, directories, and history
- 📦 **Modern CLI Tools** - bat, eza, fd, ripgrep, delta, and more
- 🛠️ **Smart Functions** - Project analysis, quick commits, and development helpers
- ⚡ **Optimized Performance** - Lazy loading and caching

## Prerequisites

- macOS (tested on macOS 14 Sonoma)
- Admin access to install Homebrew
- Internet connection

## Quick Install

### Option 1: One-liner Install (Recommended)
```bash
curl -fsSL https://raw.githubusercontent.com/AbdallahAHO/perfect-zsh/main/install.sh | bash
```

### Option 2: Clone and Install
```bash
# Clone the repository
git clone https://github.com/AbdallahAHO/perfect-zsh.git
cd perfect-zsh

# Run the setup
./setup.sh
```

### Option 3: Local Testing
If you want to test locally before committing:
```bash
cd perfect-zsh
./quick-test.sh
```

## What Gets Installed

### Package Managers
- **Homebrew** - macOS package manager
- **pnpm** - Fast, disk space efficient package manager

### Shell & Frameworks
- **Zsh** - Modern shell (already on macOS)
- **Oh My Zsh** - Zsh framework
- **Powerlevel10k** - Beautiful and fast theme

### Modern CLI Tools
- **fzf** - Fuzzy finder for files and commands
- **bat** - Better `cat` with syntax highlighting
- **eza** - Modern `ls` replacement with icons
- **fd** - Fast `find` alternative
- **ripgrep** - Ultra-fast `grep` alternative
- **delta** - Beautiful git diffs
- **zoxide** - Smarter `cd` that learns your habits
- **htop** - Interactive process viewer
- **neovim** - Modern vim editor
- **jq** - JSON processor
- **tldr** - Simplified man pages

### Development Tools
- **git** - Version control
- **gh** - GitHub CLI
- **nvm** - Node Version Manager
- **docker** - Containerization
- **direnv** - Environment variable management

## Key Bindings

### Navigation
- `Ctrl + A` - Beginning of line
- `Ctrl + E` - End of line
- `Ctrl + ←/→` - Navigate by word
- `Alt + ←/→` - Navigate by word (alternative)

### Editing
- `Ctrl + W` - Delete word backward
- `Ctrl + K` - Delete to end of line
- `Ctrl + U` - Delete to beginning of line
- `Ctrl + L` - Clear screen
- `Ctrl + X, Ctrl + E` - Edit command in editor

### History & Search
- `Ctrl + R` - Search command history
- `Ctrl + P` - Previous command
- `Ctrl + N` - Next command
- `Alt + .` - Insert last argument from previous command

### Autosuggestions
- `→` - Accept suggestion
- `End` - Accept suggestion
- `Ctrl + E` - Accept suggestion

### FZF
- `Ctrl + T` - Find files
- `Alt + C` - Change directory
- `Ctrl + R` - Search command history

## Custom Functions

### File & Directory Search
- `findf <pattern>` - Find files by name
- `findd <pattern>` - Find directories by name
- `pf` - Interactive file finder with preview
- `pd` - Interactive directory navigator
- `search-code <pattern>` - Search code content

### Git Helpers
- `gquick "message"` - Quick commit with message
- `gbrowse` - Interactive branch switcher
- `gshow` - Interactive git log browser
- `smart-commit "message"` - Auto-detect commit type

### Development
- `project-info` - Analyze current project
- `devrun` - Run development server
- `install-deps` - Install project dependencies
- `setup-env` - Create .env from template
- `test` - Run tests
- `format` - Format code
- `lint` - Lint code
- `clean-project` - Remove build artifacts

### Docker
- `dc` - docker compose
- `docker-clean` - Clean all Docker resources
- `db-connect` - Connect to database container

### Utilities
- `mkcd <dir>` - Create directory and cd into it
- `extract <file>` - Extract any archive
- `weather [location]` - Get weather
- `cheat <command>` - Get command cheatsheet
- `port <number>` - Check what's using a port
- `killport <number>` - Kill process on port

## Project Templates

Quick starters for new projects:
- `new-astro` - Create Astro project
- `new-next` - Create Next.js project
- `new-vite` - Create Vite project
- `new-ts` or `init-typescript` - Create TypeScript project

## Git Aliases

### Conventional Commits
- `gcf` - feat:
- `gcfx` - fix:
- `gcd` - docs:
- `gcs` - style:
- `gcr` - refactor:
- `gct` - test:
- `gcc` - chore:
- `gcb` - build:
- `gcp` - perf:
- `gci` - ci:

### Workflow
- `gundo` - Undo last commit (soft reset)
- `gamend` - Amend last commit
- `gfresh` - Fetch all remotes and prune
- `gmain` - Switch to main/master branch
- `gcleanup` - Delete merged branches

## Troubleshooting

### Reload Configuration
```bash
source ~/.zshrc
```

### Fix Permissions
```bash
chmod 755 ~/.zshrc
chmod -R 755 ~/.oh-my-zsh
```

### Reset to Defaults
```bash
# Backup current config
cp ~/.zshrc ~/.zshrc.backup

# Remove Oh My Zsh
rm -rf ~/.oh-my-zsh

# Remove config files
rm ~/.zshrc ~/.p10k.zsh

# Re-run setup
./setup.sh
```

### Common Issues

1. **"command not found" errors**
   - Make sure `/opt/homebrew/bin` is in your PATH
   - Run `brew doctor` to check Homebrew installation

2. **Slow startup**
   - Check for duplicate PATH entries
   - Disable unused plugins in `.zshrc`

3. **Theme not loading**
   - Run `p10k configure` to reconfigure Powerlevel10k
   - Make sure fonts are installed correctly

## Customization

### Add Custom Aliases
Edit `~/.zshrc` and add your aliases in the aliases section:
```bash
alias myalias="my command"
```

### Add Custom Functions
Add functions to `~/.zshrc`:
```bash
myfunction() {
  echo "Hello, $1!"
}
```

### Change Theme
Edit `~/.zshrc` and change:
```bash
ZSH_THEME="powerlevel10k/powerlevel10k"
```

### Add/Remove Plugins
Edit the `plugins` array in `~/.zshrc`:
```bash
plugins=(
  git
  docker
  # Add more plugins here
)
```

## Updates

### Automatic Update
Run the update script to update all components:
```bash
# If you cloned the repo
cd perfect-zsh
./update.sh

# Or download and run
curl -fsSL https://raw.githubusercontent.com/AbdallahAHO/perfect-zsh/main/update.sh | bash
```

### Manual Updates
```bash
# Update Homebrew packages
brew update && brew upgrade

# Update Oh My Zsh
omz update

# Update tldr pages
tldr --update

# Update Powerlevel10k
git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull
```

### Update Configuration Only
```bash
# Pull latest configuration
curl -O https://raw.githubusercontent.com/AbdallahAHO/perfect-zsh/main/config/zshrc.template
# Then manually merge changes into your .zshrc
```

## License

This configuration is provided as-is for personal use.

## Credits

Built with amazing open-source tools:
- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [fzf](https://github.com/junegunn/fzf)
- And many more...