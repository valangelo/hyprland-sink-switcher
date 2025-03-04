Your README.md currently has outdated dependencies and installation instructions. Here’s an improved version based on your latest changes:
Hypr Sink Switcher

A simple script to switch and control audio sinks in Hyprland using PipeWire (wpctl).
Supports swaync for notifications and allows customizable keybindings.
Features

✅ Cycle through available audio sinks
✅ Select an audio sink for volume control (without changing the default output)
✅ Adjust volume or mute the selected sink
✅ Displays notifications using swaync (if installed)
✅ Customizable keybindings for fast switching
✅ Easy install & uninstall scripts
Dependencies
Required

    PipeWire – Manages audio processing
    WirePlumber – Controls PipeWire sessions
    wpctl – Part of WirePlumber, used for controlling audio sinks

Optional (for notifications & UI selection)

    swaync – Notifications when switching sinks
    swaync/icons – Provides icons for volume/mute states
    [rofi / wofi / fuzzel] – Used for sink selection (script detects what's available)

Installation

Run the following commands:

git clone https://github.com/valangelo/hypr-sink-switcher.git ~/.config/hypr/scripts/hypr-sink-switcher
cd ~/.config/hypr/scripts/hypr-sink-switcher
./install.sh

During installation, you will be asked where to append keybindings.
Uninstallation

To remove the script and keybindings:

~/.config/hypr/scripts/hypr-sink-switcher/uninstall.sh

Keybindings (Optional)

These keybindings can be added to your Hyprland config:

# Cycle through default sinks
bind = $mainMod, XF86AudioPrev, exec, ~/.config/hypr/scripts/hypr-sink-switcher/audio_sink_switcher.sh prev
bind = $mainMod, XF86AudioNext, exec, ~/.config/hypr/scripts/hypr-sink-switcher/audio_sink_switcher.sh next

# Select sink (without changing default)
bind = $mainMod, XF86AudioPlay, exec, ~/.config/hypr/scripts/hypr-sink-switcher/audio_sink_switcher.sh select  

# Volume Control for Selected Sink
bind = $mainMod, XF86AudioRaiseVolume, exec, ~/.config/hypr/scripts/hypr-sink-switcher/audio_sink_switcher.sh +5%
bind = $mainMod, XF86AudioLowerVolume, exec, ~/.config/hypr/scripts/hypr-sink-switcher/audio_sink_switcher.sh -5%
bind = $mainMod, XF86AudioMute, exec, ~/.config/hypr/scripts/hypr-sink-switcher/audio_sink_switcher.sh mute

License

This project is licensed under the MIT License.

This README is now up to date with your latest changes.
Would you like me to add anything else? 🚀
# git-remote-add-origin-https-github.com-ValAngelo-hyprland-audio-sink-switcher
