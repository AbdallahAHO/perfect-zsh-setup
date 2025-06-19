#!/bin/bash
# One-liner installer for Perfect ZSH Setup
# Usage: curl -fsSL https://raw.githubusercontent.com/AbdallahAHO/perfect-zsh/main/install.sh | bash

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Perfect ZSH Setup Installer${NC}"
echo "==========================="
echo ""

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

echo -e "${BLUE}Downloading setup script...${NC}"

# Download the setup script
if curl -fsSL -o setup.sh "https://raw.githubusercontent.com/AbdallahAHO/perfect-zsh/main/setup.sh"; then
    echo -e "${GREEN}✓ Download successful${NC}"
else
    echo -e "${RED}✗ Download failed${NC}"
    exit 1
fi

# Make it executable
chmod +x setup.sh

# Run the setup
echo -e "${BLUE}Running setup...${NC}"
./setup.sh

# Clean up
cd ~
rm -rf "$TEMP_DIR"

echo -e "${GREEN}✓ Installation complete!${NC}"