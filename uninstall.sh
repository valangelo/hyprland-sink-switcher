#!/bin/bash

# Define script path
SCRIPT_DIR="$HOME/.config/hypr/UserScripts/hypr-sink-switcher"
KEYBINDS_PATH_FILE="$SCRIPT_DIR/keybinds_path.txt"

# Check if the install directory exists
if [[ ! -d "$SCRIPT_DIR" ]]; then
    echo "Hypr Sink Switcher not found. Skipping uninstallation."
    exit 1
fi

# Read the stored keybinds file path
if [[ -f "$KEYBINDS_PATH_FILE" ]]; then
    CONFIG_PATH=$(cat "$KEYBINDS_PATH_FILE")
    if [[ -f "$CONFIG_PATH" ]]; then
        echo "Please manually remove the following line from $CONFIG_PATH:"
        echo "source=$SCRIPT_DIR/audio_sink_keybinds.conf"
    else
        echo "Stored keybinds file not found."
    fi
    # Remove the keybinds path file
    rm "$KEYBINDS_PATH_FILE"
else
    echo "Stored keybinds file path not found."
fi

# Remove the script directory
rm -rf "$SCRIPT_DIR"

echo "Hypr Sink Switcher uninstalled successfully!"