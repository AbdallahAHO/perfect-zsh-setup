#!/bin/bash
# Quick CLI utility for Perfect ZSH Setup

show_help() {
    echo "Perfect ZSH Setup - Quick CLI"
    echo "============================="
    echo ""
    echo "Commands:"
    echo "  setup        Run interactive setup"
    echo "  quick        Quick setup with defaults"
    echo "  config       Edit configuration file"
    echo "  presets      Show available presets"
    echo "  status       Show current configuration"
    echo "  update       Update all tools"
    echo "  help         Show this help"
    echo ""
}

case "${1:-}" in
    "setup")
        ./setup-enhanced.sh --config
        ;;
    "quick")
        ./setup-enhanced.sh --quick
        ;;
    "config")
        ${EDITOR:-code} config/setup.conf
        ;;
    "presets")
        echo "Available presets:"
        echo "  web-developer  - Full web development stack"
        echo "  minimal        - Essential tools only"
        echo "  fullstack      - Complete development environment"
        echo ""
        echo "To use a preset:"
        echo "  cp config/presets/PRESET.conf config/setup.conf"
        echo "  ./setup-enhanced.sh --quick"
        ;;
    "status")
        if [ -f "config/setup.conf" ]; then
            echo "Current configuration summary:"
            echo "=============================="
            grep -E "^INSTALL_(NVM|PYENV|RBENV|VSCODE|CURSOR|CHROME|DOCKER)=" config/setup.conf | sed 's/INSTALL_//' | sed 's/=/ = /'
        else
            echo "No configuration file found. Run './cli.sh setup' to get started."
        fi
        ;;
    "update")
        if command -v brew &> /dev/null; then
            echo "Updating Homebrew..."
            brew update && brew upgrade
            echo "Updating Oh My Zsh..."
            cd ~/.oh-my-zsh && git pull
            echo "Update complete!"
        else
            echo "Homebrew not found. Please run setup first."
        fi
        ;;
    "help"|"--help"|"-h")
        show_help
        ;;
    "")
        echo "Perfect ZSH Setup"
        echo "Run './cli.sh help' for available commands"
        ;;
    *)
        echo "Unknown command: $1"
        echo "Run './cli.sh help' for available commands"
        ;;
esac