#!/bin/bash

# Installation instructions:
# 1. Save this script in a file, e.g., `editor-select.sh`.
# 2. Make the script executable: chmod +x editor-select.sh
# 3. Copy the script to a user-managed bin folder, e.g.: cp editor-select.sh ~/bin/editor-select
# 4. Add the following aliases to your shell configuration file (e.g., ~/.bashrc or ~/.zshrc):
#    alias vim='~/bin/editor-select'
#    alias nano='~/bin/editor-select'

# Prompt the user for editor choice
echo "Do you want to use vim, micro, or nano? (v/m/n) [Default: m]"
read -r editor_choice

# Set default choice to 'm' if no input is provided
editor_choice=${editor_choice:-m}

# Start the editor based on the user's choice
case "$editor_choice" in
    v|V)
        vim "$@"
        ;;
    m|M)
        micro "$@"
        ;;
    n|N)
        nano "$@"
        ;;
    *)
        echo "Invalid choice. Please choose 'v' for vim, 'm' for micro, or 'n' for nano."
        exit 1
        ;;
esac