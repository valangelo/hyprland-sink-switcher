#!/bin/bash

# Define script paths
SCRIPT_DIR="$HOME/.config/hypr/scripts/hypr-sink-switcher"
SCRIPT_NAME="audio_sink_switcher.sh"
SCRIPT_PATH="$SCRIPT_DIR/$SCRIPT_NAME"
KEYBINDS_CONF="$SCRIPT_DIR/audio_sink_keybinds.conf"

# Define Hyprland config paths
DEFAULT_HYPRCONF="$HOME/.config/hypr/hyprland.conf"
USER_KEYBINDS="$HOME/.config/hypr/UserConfigs/UserKeybinds.conf"

echo "This will uninstall the Hyprland Audio Sink Switcher."

# Ask the user if they want to remove the script
read -p "Do you want to remove the script? (y/N): " REMOVE_SCRIPT
if [[ "$REMOVE_SCRIPT" =~ ^[Yy]$ ]]; then
    echo "Removing script files..."
    rm -rf "$SCRIPT_DIR"
    echo "Script files removed."
else
    echo "Skipping script removal."
fi

# Ask if the user wants to remove keybinds
read -p "Do you want to remove keybinds from Hyprland config? (y/N): " REMOVE_KEYBINDS
if [[ "$REMOVE_KEYBINDS" =~ ^[Yy]$ ]]; then
    echo "Where do you want to remove the keybinds from?"
    echo "1) Default (hyprland.conf)"
    echo "2) UserKeybinds.conf"
    echo "3) Custom path"
    echo "4) Skip removing keybinds"
    read -p "Enter choice (1/2/3/4): " CHOICE

    case "$CHOICE" in
        1) CONFIG_PATH="$DEFAULT_HYPRCONF" ;;
        2) CONFIG_PATH="$USER_KEYBINDS" ;;
        3) read -p "Enter the full path for your keybinds file: " CONFIG_PATH ;;
        4) CONFIG_PATH="" ;; # Skip removing keybinds
        *) echo "Invalid choice, skipping keybinds removal."; CONFIG_PATH="" ;;
    esac

    if [[ -n "$CONFIG_PATH" && -f "$CONFIG_PATH" ]]; then
        echo "Removing keybinds from $CONFIG_PATH..."
        sed -i "/$(head -n 1 "$KEYBINDS_CONF")/,/$(tail -n 1 "$KEYBINDS_CONF")/d" "$CONFIG_PATH"
        echo "Keybinds removed."
    else
        echo "Skipping keybinds removal."
    fi
else
    echo "Skipping keybinds removal."
fi

# Reload Hyprland config
hyprctl reload

echo "Uninstallation complete."
