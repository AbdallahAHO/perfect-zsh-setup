#!/bin/bash

# Perfect ZSH Setup Script for macOS
# This script sets up a fully-featured zsh environment with modern tools

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
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

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS only"
    exit 1
fi

print_step "Starting Perfect ZSH Setup..."

# Install Xcode Command Line Tools if needed
if ! xcode-select -p &> /dev/null; then
    print_step "Installing Xcode Command Line Tools..."
    xcode-select --install
    print_warning "Please complete the Xcode Command Line Tools installation and then re-run this script"
    exit 0
fi

# Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    print_step "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    print_success "Homebrew already installed"
fi

# Update Homebrew
print_step "Updating Homebrew..."
brew update

# Install essential tools
print_step "Installing essential CLI tools..."
brew_packages=(
    "git"
    "gh"
    "wget"
    "curl"
    "jq"
    "tree"
)

for package in "${brew_packages[@]}"; do
    if brew list "$package" &> /dev/null; then
        print_success "$package already installed"
    else
        brew install "$package"
    fi
done

# Install modern CLI tools
print_step "Installing modern CLI tools..."
modern_tools=(
    "fzf"
    "bat"
    "eza"
    "fd"
    "ripgrep"
    "git-delta"
    "zoxide"
    "htop"
    "neovim"
    "tldr"
    "direnv"
)

for tool in "${modern_tools[@]}"; do
    if brew list "$tool" &> /dev/null; then
        print_success "$tool already installed"
    else
        brew install "$tool"
    fi
done

# Install zsh plugins
print_step "Installing ZSH plugins..."
brew install zsh-autosuggestions zsh-syntax-highlighting

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_step "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_success "Oh My Zsh already installed"
fi

# Install Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    print_step "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
else
    print_success "Powerlevel10k already installed"
fi

# Install FZF key bindings
print_step "Installing FZF key bindings..."
$(brew --prefix)/opt/fzf/install --all --no-bash --no-fish --no-update-rc

# Install Node Version Manager (NVM)
if [ ! -d "$HOME/.nvm" ]; then
    print_step "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
else
    print_success "NVM already installed"
fi

# Install pnpm
if ! command -v pnpm &> /dev/null; then
    print_step "Installing pnpm..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -
else
    print_success "pnpm already installed"
fi

# Backup existing .zshrc if it exists
if [ -f "$HOME/.zshrc" ]; then
    print_step "Backing up existing .zshrc..."
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
fi

# Create the perfect .zshrc
print_step "Creating perfect .zshrc configuration..."
cat > "$HOME/.zshrc" << 'EOF'
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =======================================
# PATH Configuration
# =======================================
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:$HOME/.local/bin"

# =======================================
# Oh My Zsh Configuration
# =======================================
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable completion waiting dots
COMPLETION_WAITING_DOTS="true"

# History timestamps
HIST_STAMPS="yyyy-mm-dd"

# Load Oh My Zsh plugins
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
  bundler
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
export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'
export LESS='-R -F -X'

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
fi

# =======================================
# Shell Options
# =======================================
setopt AUTO_CD                # Go to folder without cd
setopt AUTO_PUSHD             # Push directories on every cd
setopt PUSHD_IGNORE_DUPS      # No duplicates in dir stack
setopt PUSHD_SILENT           # No dir stack after pushd or popd
setopt CORRECT                # Spelling correction
setopt CDABLE_VARS            # Change directory to a path stored in a variable
setopt EXTENDED_GLOB          # Use extended globbing syntax
setopt GLOB_DOTS              # Include dotfiles in globbing
setopt NO_BEEP                # No beep
setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS     # Remove blanks from history items
setopt HIST_VERIFY            # Show command with history expansion before running it
setopt SHARE_HISTORY          # Share history between sessions
setopt EXTENDED_HISTORY       # Save timestamp and duration
setopt INC_APPEND_HISTORY     # Add commands immediately

# History configuration
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

# =======================================
# Key Bindings
# =======================================
bindkey -e  # Emacs key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^U' backward-kill-line
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Additional useful key bindings
bindkey '^P' up-line-or-search
bindkey '^N' down-line-or-search
bindkey '^W' backward-kill-word
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
bindkey '^K' kill-line
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward
bindkey '^L' clear-screen
bindkey '^[.' insert-last-word

# Enable edit command in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Smart word navigation
bindkey '^[[1;5C' forward-word  # Ctrl+Right
bindkey '^[[1;5D' backward-word # Ctrl+Left
bindkey '^[^[[C' forward-word   # Alt+Right
bindkey '^[^[[D' backward-word  # Alt+Left

# =======================================
# Aliases - General
# =======================================
alias zshconfig="$EDITOR ~/.zshrc"
alias zshreload="source ~/.zshrc"
alias ohmyzsh="$EDITOR ~/.oh-my-zsh"

# Better defaults
alias ls='eza --icons --group-directories-first'
alias ll='eza -alh --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias lt='eza --tree --icons -a -I ".git|node_modules|.cache|.venv"'
alias l='eza -lah --icons --group-directories-first'

alias cat='bat --style=plain --paging=never'
alias less='bat --style=plain'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'

alias df='df -h'
alias du='du -h'
alias free='free -h'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# =======================================
# Aliases - Development
# =======================================
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

alias dk='docker'
alias dkc='docker compose'
alias dkps='docker ps'
alias dkpsa='docker ps -a'
alias dki='docker images'
alias dkrm='docker rm'
alias dkrmi='docker rmi'

alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kaf='kubectl apply -f'
alias kdel='kubectl delete'
alias klog='kubectl logs'
alias kexec='kubectl exec -it'

alias py='python3'
alias pip='pip3'
alias venv='python3 -m venv'
alias activate='source venv/bin/activate'

alias n='npm'
alias nr='npm run'
alias ni='npm install'
alias nid='npm install --save-dev'
alias nu='npm uninstall'
alias nup='npm update'
alias nri='rm -rf node_modules package-lock.json && npm install'

alias y='yarn'
alias ya='yarn add'
alias yad='yarn add --dev'
alias yr='yarn remove'
alias yu='yarn upgrade'
alias yui='yarn upgrade-interactive'

# =======================================
# Aliases - System
# =======================================
alias ports='netstat -tulanp'
alias update='brew update && brew upgrade && brew cleanup'
alias cleanup='find . -type f -name "*.DS_Store" -ls -delete'
alias flush='dscacheutil -flushcache && killall -HUP mDNSResponder'
alias afk='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'
alias reload='exec ${SHELL} -l'
alias path='echo -e ${PATH//:/\\n}'

# =======================================
# Aliases - Quick Access
# =======================================
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
alias dev="cd ~/Development"
alias docs="cd ~/Documents"

# =======================================
# Functions
# =======================================
# Create directory and cd into it
mkcd() {
  mkdir -p "$@" && cd "$_"
}

# Extract archives
extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2)   tar xjf "$1"   ;;
      *.tar.gz)    tar xzf "$1"   ;;
      *.bz2)       bunzip2 "$1"   ;;
      *.rar)       unrar x "$1"   ;;
      *.gz)        gunzip "$1"    ;;
      *.tar)       tar xf "$1"    ;;
      *.tbz2)      tar xjf "$1"   ;;
      *.tgz)       tar xzf "$1"   ;;
      *.zip)       unzip "$1"     ;;
      *.Z)         uncompress "$1";;
      *.7z)        7z x "$1"      ;;
      *)           echo "'$1' cannot be extracted" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Find file by name (using fd for better performance)
findf() {
  if command -v fd &> /dev/null; then
    fd --type f "$1"
  else
    find . -type f -name "*$1*"
  fi
}

# Find directory by name
findd() {
  if command -v fd &> /dev/null; then
    fd --type d "$1"
  else
    find . -type d -name "*$1*"
  fi
}

# Quick git commit with message
gquick() {
  git commit -m "$*"
}

# Quick look file (macOS)
ql() {
  qlmanage -p "$*" >& /dev/null
}

# Check port usage
port() {
  lsof -i :$1
}

# Kill process on port
killport() {
  lsof -ti :$1 | xargs kill -9
}

# Weather
weather() {
  curl "wttr.in/${1:-}"
}

# Cheatsheet
cheat() {
  curl "cheat.sh/$1"
}

# =======================================
# Tool Configurations
# =======================================
# FZF configuration
export FZF_DEFAULT_COMMAND='/opt/homebrew/bin/fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --inline-info
  --preview "bat --style=numbers --color=always --line-range :500 {}"
  --preview-window=right:60%:wrap
  --bind="ctrl-d:preview-page-down"
  --bind="ctrl-u:preview-page-up"
'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS"
export FZF_ALT_C_COMMAND='/opt/homebrew/bin/fd --type d --hidden --follow --exclude .git'
export FZF_ALT_C_OPTS="--preview 'eza --tree --icons --level=2 {}'"

# Bat configuration
export BAT_THEME="TwoDark"

# Zoxide configuration
eval "$(zoxide init zsh)"

# =======================================
# Development Tools
# =======================================
# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Lazy load NVM
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"

# Rust
[ -s "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Python
export PYTHONDONTWRITEBYTECODE=1
export PYTHONUNBUFFERED=1

# =======================================
# Completion
# =======================================
# Load completions
autoload -Uz compinit
compinit

# Enable completion caching
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.cache/zsh/.zcompcache"

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'

# Colored completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Menu selection
zstyle ':completion:*' menu select

# Verbose completion
zstyle ':completion:*' verbose yes

# Group results
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%B%d%b'

# Better completion formatting
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# Fuzzy matching of completions
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Environment Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# Populate hostname completion
zstyle -e ':completion:*:hosts' hosts 'reply=(
  ${=${=${=${${(f)"$(cat {/etc/ssh_,~/.ssh/known_}hosts(|2)(N) 2>/dev/null)"}%%[#| ]*}//\]:[0-9]*/ }//,/ }//\[/ }
  ${=${(f)"$(cat /etc/hosts(|)(N) <<(ypcat hosts 2>/dev/null))"}%%\#*}
  ${=${${${${(@M)${(f)"$(cat ~/.ssh/config 2>/dev/null)"}:#Host *}#Host }:#*\**}:#*\?*}}
)'

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
  adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
  dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
  hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
  mailman mailnull mldonkey mysql nagios \
  named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
  operator pcap postfix postgres privoxy pulse pvm quagga radvd \
  rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs '_*'

# ... unless we really want to.
zstyle '*' single-ignored show

# Ignore multiple entries.
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# Kill
zstyle ':completion:*:*:*:*:processes' command 'ps -u $LOGNAME -o pid,user,command -w'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# SSH/SCP/RSYNC
zstyle ':completion:*:(scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:(scp|rsync):*' group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ipaddr:ip\ address *'
zstyle ':completion:*:ssh:*' group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

# =======================================
# Local configurations
# =======================================
[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# =======================================
# Third-party integrations
# =======================================
# Direnv
which direnv > /dev/null && eval "$(direnv hook zsh)"

# ZSH Autosuggestions
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Autosuggestions configuration
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_MANUAL_REBIND=true
ZSH_AUTOSUGGEST_COMPLETION_IGNORE="git *"
ZSH_AUTOSUGGEST_HISTORY_IGNORE="cd *"

# Accept autosuggestion with right arrow or end key
bindkey '→' autosuggest-accept
bindkey '^[[F' autosuggest-accept
bindkey '^E' autosuggest-accept

# ZSH Syntax Highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Syntax highlighting configuration
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=green'
ZSH_HIGHLIGHT_STYLES[path]='fg=cyan,underline'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[assign]='fg=magenta'

# =======================================
# Final configurations
# =======================================
# FZF must be loaded after oh-my-zsh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Remove duplicate PATH entries
typeset -U PATH

# =======================================
# Advanced Development Functions
# =======================================
# Project analysis
project-info() {
  echo "=== Project Analysis ==="
  echo "Directory: $(pwd)"
  
  # Detect project type and package manager
  if [ -f "package.json" ]; then
    echo "Type: Node.js/JavaScript"
    if [ -f "pnpm-lock.yaml" ]; then
      echo "Package Manager: pnpm"
    elif [ -f "yarn.lock" ]; then
      echo "Package Manager: yarn"
    else
      echo "Package Manager: npm"
    fi
    
    # Show available scripts
    echo -e "\nAvailable scripts:"
    jq -r '.scripts | to_entries[] | "  \(.key): \(.value)"' package.json 2>/dev/null | head -10
    
    # Check TypeScript
    [ -f "tsconfig.json" ] && echo -e "\n✓ TypeScript configured"
  fi
  
  # Other project types
  [ -f "Cargo.toml" ] && echo "Type: Rust"
  [ -f "go.mod" ] && echo "Type: Go"
  [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] && echo "Type: Python"
  [ -f "composer.json" ] && echo "Type: PHP"
  
  # Development tools
  echo -e "\nDevelopment setup:"
  [ -f "docker-compose.yml" ] && echo "  ✓ Docker Compose"
  [ -f ".env.example" ] && echo "  ✓ Environment template"
  [ -f "biome.json" ] && echo "  ✓ Biome formatter"
  [ -d ".github/workflows" ] && echo "  ✓ GitHub Actions"
  [ -f "playwright.config.ts" ] && echo "  ✓ Playwright tests"
  [ -f ".eslintrc" ] || [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ] && echo "  ✓ ESLint"
}

# Quick TypeScript project setup
init-typescript() {
  echo "Initializing TypeScript project..."
  pnpm init
  pnpm add -D typescript @types/node tsx biome @tsconfig/node20
  
  # Create tsconfig.json
  cat > tsconfig.json << 'TSEOF'
{
  "extends": "@tsconfig/node20/tsconfig.json",
  "compilerOptions": {
    "outDir": "./dist",
    "rootDir": "./src"
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
TSEOF
  
  # Create biome.json
  cat > biome.json << 'BIOMEEOF'
{
  "formatter": {
    "enabled": true,
    "indentStyle": "space"
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true
    }
  }
}
BIOMEEOF
  
  mkdir -p src
  echo 'console.log("Hello, TypeScript!")' > src/index.ts
  
  # Update package.json scripts
  npx json -I -f package.json -e 'this.scripts={"dev":"tsx src/index.ts","build":"tsc","start":"node dist/index.js","format":"biome format --write ./src","lint":"biome check ./src","typecheck":"tsc --noEmit"}'
}

# Smart git commit with type detection
smart-commit() {
  local message="$1"
  local files=$(git diff --cached --name-only)
  
  # Auto-detect commit type based on files
  local type=""
  if echo "$files" | grep -q "test\|spec"; then
    type="test"
  elif echo "$files" | grep -q "docs\|README\|CHANGELOG"; then
    type="docs"
  elif echo "$files" | grep -q "package.*json\|lock\|yarn\|pnpm"; then
    type="chore"
  elif echo "$files" | grep -q "fix\|bug\|issue"; then
    type="fix"
  else
    type="feat"
  fi
  
  # Allow override
  if [[ "$message" == *":"* ]]; then
    git commit -m "$message"
  else
    git commit -m "$type: $message"
  fi
}

# Enhanced project search
find-in-project() {
  rg --hidden --no-ignore-vcs -g '!{.git,node_modules,dist,build,coverage}' "$@"
}

# Quick environment setup
setup-env() {
  if [ -f ".env.example" ] && [ ! -f ".env" ]; then
    cp .env.example .env
    echo "Created .env from .env.example"
    ${EDITOR:-nvim} .env
  else
    echo "No .env.example found or .env already exists"
  fi
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
    pnpm install  # Default to pnpm
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
    elif jq -e '.scripts.serve' package.json > /dev/null; then
      pnpm serve || npm run serve
    else
      echo "No dev script found in package.json"
    fi
  elif [ -f "Cargo.toml" ]; then
    cargo run
  elif [ -f "main.go" ]; then
    go run .
  elif [ -f "manage.py" ]; then
    python manage.py runserver
  else
    echo "No recognized dev command for this project"
  fi
}

# Clean project artifacts
clean-project() {
  echo "Cleaning project artifacts..."
  
  # Node.js
  [ -d "node_modules" ] && rm -rf node_modules && echo "Removed node_modules"
  [ -d "dist" ] && rm -rf dist && echo "Removed dist"
  [ -d "build" ] && rm -rf build && echo "Removed build"
  [ -d ".next" ] && rm -rf .next && echo "Removed .next"
  [ -d "coverage" ] && rm -rf coverage && echo "Removed coverage"
  
  # Python
  find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null && echo "Removed __pycache__"
  find . -type f -name "*.pyc" -delete 2>/dev/null && echo "Removed .pyc files"
  
  # General
  find . -name ".DS_Store" -delete 2>/dev/null && echo "Removed .DS_Store files"
}

# =======================================
# Enhanced Git Aliases
# =======================================
# Conventional commits without signatures
alias gcf='git commit -m "feat: "'
alias gcfx='git commit -m "fix: "'
alias gcd='git commit -m "docs: "'
alias gcs='git commit -m "style: "'
alias gcr='git commit -m "refactor: "'
alias gct='git commit -m "test: "'
alias gcc='git commit -m "chore: "'
alias gcb='git commit -m "build: "'
alias gcp='git commit -m "perf: "'
alias gci='git commit -m "ci: "'

# Git workflow helpers
alias gundo='git reset --soft HEAD~1'
alias gamend='git commit --amend --no-edit'
alias gfresh='git fetch --all --prune'
alias gmain='git checkout main || git checkout master'
alias gcleanup='git branch --merged | grep -v "\*\|main\|master" | xargs -n 1 git branch -d'

# =======================================
# Advanced FZF Commands
# =======================================
# Project file finder with preview
pf() {
  local file
  file=$(/opt/homebrew/bin/fd --type f --hidden --follow --exclude .git --exclude node_modules \
    | fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' \
          --preview-window=right:60%:wrap)
  [ -n "$file" ] && ${EDITOR:-nvim} "$file"
}

# Interactive project directory navigation
pd() {
  local dir
  dir=$(/opt/homebrew/bin/fd --type d --hidden --follow --exclude .git --exclude node_modules \
    | fzf --preview 'eza --tree --icons --level=2 --color=always {}')
  [ -n "$dir" ] && cd "$dir"
}

# Search code content and open in editor
search-code() {
  local selection
  selection=$(rg --line-number --no-heading --color=always "$1" \
    | fzf --ansi --delimiter=':' \
          --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
          --preview-window=right:60%:wrap)
  
  if [ -n "$selection" ]; then
    local file=$(echo "$selection" | cut -d: -f1)
    local line=$(echo "$selection" | cut -d: -f2)
    ${EDITOR:-nvim} "$file" +$line
  fi
}

# Git branch switcher with preview
gbrowse() {
  local branch
  branch=$(git branch --all | grep -v HEAD \
    | fzf --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(echo {} | sed "s/.* //")' \
          --preview-window=right:60%:wrap)
  
  if [ -n "$branch" ]; then
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
  fi
}

# Interactive git log browser
gshow() {
  git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
              (grep -o '[a-f0-9]\{7\}' | head -1 |
              xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
              {}
FZF-EOF"
}

# =======================================
# Docker Aliases & Functions
# =======================================
# Docker shortcuts
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
alias dce='docker compose exec'
alias dcr='docker compose restart'
alias dcp='docker compose ps'
alias dcb='docker compose build'

# Docker cleanup
docker-clean() {
  echo "Cleaning Docker resources..."
  docker compose down --volumes --remove-orphans 2>/dev/null
  docker system prune -af --volumes
  echo "Docker cleanup complete"
}

# Quick database connections
db-connect() {
  if [ -f "docker-compose.yml" ]; then
    local service=$(docker compose ps --services | fzf --prompt="Select database service: ")
    [ -n "$service" ] && docker compose exec "$service" bash
  else
    echo "No docker-compose.yml found"
  fi
}

# =======================================
# Testing & Quality Functions
# =======================================
# Run tests intelligently
test() {
  if [ -f "package.json" ]; then
    if jq -e '.scripts.test' package.json > /dev/null; then
      pnpm test "$@" || npm test "$@"
    else
      echo "No test script found"
    fi
  elif [ -f "Cargo.toml" ]; then
    cargo test "$@"
  elif [ -f "go.mod" ]; then
    go test ./... "$@"
  elif [ -f "pytest.ini" ] || [ -f "setup.cfg" ]; then
    pytest "$@"
  else
    echo "No test configuration found"
  fi
}

# Format code
format() {
  if [ -f "biome.json" ]; then
    biome format --write .
  elif [ -f "package.json" ] && jq -e '.scripts.format' package.json > /dev/null; then
    pnpm format || npm run format
  elif [ -f ".prettierrc" ] || [ -f "prettier.config.js" ]; then
    prettier --write .
  elif [ -f "Cargo.toml" ]; then
    cargo fmt
  elif [ -f "go.mod" ]; then
    go fmt ./...
  else
    echo "No formatter configuration found"
  fi
}

# Lint code
lint() {
  if [ -f "biome.json" ]; then
    biome check .
  elif [ -f "package.json" ] && jq -e '.scripts.lint' package.json > /dev/null; then
    pnpm lint || npm run lint
  elif [ -f ".eslintrc" ] || [ -f ".eslintrc.js" ] || [ -f ".eslintrc.json" ]; then
    eslint .
  elif [ -f "Cargo.toml" ]; then
    cargo clippy
  elif [ -f "go.mod" ]; then
    golangci-lint run
  else
    echo "No linter configuration found"
  fi
}

# =======================================
# Project Templates
# =======================================
alias new-astro='pnpm create astro@latest'
alias new-next='pnpm create next-app@latest'
alias new-vite='pnpm create vite@latest'
alias new-ts='init-typescript'
EOF

# Create cache directory
mkdir -p "$HOME/.cache/zsh"

# Download and configure Powerlevel10k if not already configured
if [ ! -f "$HOME/.p10k.zsh" ]; then
    print_step "Configuring Powerlevel10k..."
    # Download a sensible default configuration
    curl -fsSL https://raw.githubusercontent.com/romkatv/powerlevel10k/master/config/p10k-lean.zsh > "$HOME/.p10k.zsh"
fi

# Install recommended fonts
print_step "Installing recommended fonts..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Install Nerd Fonts
    brew tap homebrew/cask-fonts
    brew install --cask font-meslo-lg-nerd-font || true
fi

# Final setup
print_step "Running final setup..."

# Source the new configuration
source "$HOME/.zshrc"

# Success message
print_success "Perfect ZSH setup complete! 🎉"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.zshrc"
echo "2. If fonts look wrong, configure your terminal to use 'MesloLGS NF' font"
echo "3. Run 'p10k configure' to customize your prompt"
echo ""
echo "Useful commands to try:"
echo "  - pf          : Find files interactively"
echo "  - pd          : Navigate directories"
echo "  - project-info: Analyze current project"
echo "  - z <partial> : Jump to frequently used directories"
echo "  - Ctrl+R      : Search command history"
echo "  - Ctrl+T      : Find files with FZF"
echo ""
print_success "Enjoy your perfect ZSH setup!"
EOF

# Make the script executable
chmod +x "$HOME/.perfect-zsh-setup.sh"

# Move it to the created file location
mv "$HOME/.perfect-zsh-setup.sh" "/Users/abdallah.othman/Developer/Personal/setup-perfect-zsh.sh"

print_success "Setup script created successfully!"