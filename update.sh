#!/bin/bash

# Update script for Perfect ZSH Setup

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Perfect ZSH Setup Updater${NC}"
echo "=========================="
echo ""

# Update Homebrew packages
echo -e "${BLUE}Updating Homebrew packages...${NC}"
brew update
brew upgrade

# Update Oh My Zsh
echo -e "${BLUE}Updating Oh My Zsh...${NC}"
$ZSH/tools/upgrade.sh

# Update Powerlevel10k
echo -e "${BLUE}Updating Powerlevel10k...${NC}"
git -C ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k pull

# Update tldr
echo -e "${BLUE}Updating tldr pages...${NC}"
tldr --update

# Update zsh plugins
echo -e "${BLUE}Updating ZSH plugins...${NC}"
brew upgrade zsh-autosuggestions zsh-syntax-highlighting

echo ""
echo -e "${GREEN}✓ All components updated successfully!${NC}"
echo ""
echo "Restart your terminal or run 'source ~/.zshrc' to apply updates."