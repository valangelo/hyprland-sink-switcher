#!/bin/bash

# Define script path
SCRIPT_DIR="$HOME/.config/hypr/UserScripts/hypr-sink-switcher"
SCRIPT_NAME="audio_sink_switcher.sh"
SCRIPT_PATH="$SCRIPT_DIR/$SCRIPT_NAME"

# Ensure the directory exists
mkdir -p "$SCRIPT_DIR"

# Copy the script if it's not already there (adjust the source path as needed)
if [[ ! -f "$SCRIPT_PATH" ]]; then
    echo "Copying $SCRIPT_NAME to $SCRIPT_DIR..."
    cp "$(dirname "$0")/$SCRIPT_NAME" "$SCRIPT_PATH"
fi

# Make sure it's executable
chmod +x "$SCRIPT_PATH"

# Ensure dependencies are installed (PipeWire/`wpctl`)
if ! command -v wpctl &> /dev/null; then
    echo "PipeWire 'wpctl' not found. Please install WirePlumber or PipeWire!"
    exit 1
fi

# Define the keybinds config path
KEYBINDS_CONF="$SCRIPT_DIR/audio_sink_keybinds.conf"

# Copy the keybinds config if it's not already there
if [[ ! -f "$KEYBINDS_CONF" ]]; then
    echo "Copying audio_sink_keybinds.conf to $SCRIPT_DIR..."
    cp "$(dirname "$0")/audio_sink_keybinds.conf" "$KEYBINDS_CONF"
fi

# Ask the user where to append keybinds
DEFAULT_HYPRCONF="$HOME/.config/hypr/hyprland.conf"
USER_KEYBINDS="$HOME/.config/hypr/UserConfigs/UserKeybinds.conf"

echo "The following keybindings will be added to your Hyprland config:"
echo ""
echo "  🎛  Super + XF86AudioPrev    → Cycle to the previous audio sink"
echo "  🎛  Super + XF86AudioNext    → Cycle to the next audio sink"
echo "  🎛  Super + XF86AudioPlay    → Show a launcher to select a sink (without changing default)"
echo "  🔊  Super + XF86AudioRaise   → Increase volume of the selected sink"
echo "  🔉  Super + XF86AudioLower   → Decrease volume of the selected sink"
echo "  🔇  Super + XF86AudioMute    → Mute/unmute the selected sink"
echo ""

# Ask the user where to append keybinds
echo "Where do you want to append the keybinds?"
echo "1) Default (hyprland.conf)"
echo "2) UserKeybinds.conf"
echo "3) Custom path"
echo "4) Skip appending keybinds"
read -p "Enter choice (1/2/3/4): " CHOICE

case "$CHOICE" in
    1) CONFIG_PATH="$DEFAULT_HYPRCONF" ;;
    2) CONFIG_PATH="$USER_KEYBINDS" ;;
    3) read -p "Enter the full path for your keybinds file: " CONFIG_PATH ;;
    4) CONFIG_PATH="" ;; # Skip appending
    *) echo "Invalid choice, skipping keybinds append."; CONFIG_PATH="" ;;
esac

# Append keybinds if the user didn't skip
if [[ -n "$CONFIG_PATH" ]]; then
    if [[ -f "$CONFIG_PATH" ]]; then
        echo "Appending keybinds to $CONFIG_PATH..."

        # Check if $mainMod is already defined
        if grep -q "^mainMod =" "$CONFIG_PATH"; then
            echo "\$mainMod is already defined in $CONFIG_PATH. Skipping \$mainMod definition."
            # Remove the line with mainMod definition from the keybinds config file
            sed -i '/^mainMod =/d' "$KEYBINDS_CONF"
        fi

        cat "$KEYBINDS_CONF" >> "$CONFIG_PATH"
        echo "Keybinds added successfully!"
    else
        echo "Error: Config file not found at $CONFIG_PATH. Skipping keybinds append."
    fi
else
    echo "Skipping keybinds append."
fi

# Reload Hyprland config
hyprctl reload

echo "Audio sink switcher installed successfully!"
