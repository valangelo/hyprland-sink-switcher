# Hypr Sink Switcher

As someone new to Hyprland, I found managing audio outputs and individual sink volumes to be cumbersome. 

✨ **Features**

* ✅ Cycle through available audio sinks as your default output (SUPER + XF86AudioPrev/Next)
* ✅ Select an audio sink for individual volume control (SUPER + XF86AudioPlay) without affecting the default output.
* ✅ Adjust volume or mute the selected sink (SUPER + XF86AudioRaiseVolume/LowerVolume/Mute).
* ✅ Displays notifications using swaync (if installed)
* ✅ Customizable keybindings for fast switching
* ✅ Easy install & uninstall scripts

**How it Works:**

1.  **Switching Default Sinks:**
    * Pressing `SUPER + XF86AudioPrev` or `SUPER + XF86AudioNext` cycles through your available audio outputs, changing the system's default audio sink. This is ideal for quickly switching between headphones, speakers, etc.

2.  **Selecting a Sink for Volume Control:**
    * Pressing `SUPER + XF86AudioPlay` opens a selection menu (using rofi, wofi, or fuzzel) where you can choose a specific audio sink. This selection does *not* change the system's default output.
    * This selected sink is then used for volume adjustments.

3.  **Controlling Individual Sink Volumes:**
    * After selecting a sink with `SUPER + XF86AudioPlay`, you can control its volume using:
        * `SUPER + XF86AudioRaiseVolume` (+5%)
        * `SUPER + XF86AudioLowerVolume` (-5%)
        * `SUPER + XF86AudioMute` (toggle mute)
    * These volume controls affect only the sink you selected, allowing you to fine-tune individual audio outputs without changing the system's default.

✨ **Features**

* ✅ Cycle through available audio sinks
* ✅ Select an audio sink for volume control (without changing the default output)
* ✅ Adjust volume or mute the selected sink
* ✅ Displays notifications using swaync (if installed)
* ✅ Customizable keybindings for fast switching
* ✅ Easy install & uninstall scripts

🛠 **Dependencies**

**Required**

* PipeWire – Manages audio processing
* WirePlumber – Controls PipeWire sessions
* wpctl – Part of WirePlumber, used for controlling audio sinks

**Optional (for notifications & UI selection)**

* swaync – Notifications when switching sinks
* swaync/icons – Provides icons for volume/mute states
* [rofi / wofi / fuzzel] – Used for sink selection (script detects what's available)

# 📦 **Installation**

Run the following commands:

```bash
git clone [https://github.com/valangelo/hypr-sink-switcher.git](https://github.com/valangelo/hypr-sink-switcher.git) ~/.config/hypr/scripts/hypr-sink-switcher
cd ~/.config/hypr/scripts/hypr-sink-switcher
./install.sh
```
During installation, you will be asked where to append keybindings.

🗑 Uninstallation

To remove the script and keybindings:
Bash
```
~/.config/hypr/scripts/hypr-sink-switcher/uninstall.sh
```

# 🎮 Keybindings (Optional)

During installation, you will have the option to automatically append the following keybindings to your Hyprland configuration.

```

#############
# Audio Control (Hypr Sink Switcher)
#############

# Cycle through system default sinks
bind = $mainMod, XF86AudioPrev, exec, ~/.config/hypr/scripts/hypr-sink-switcher/audio_sink_switcher.sh prev
bind = $mainMod, XF86AudioNext, exec, ~/.config/hypr/scripts/hypr-sink-switcher/audio_sink_switcher.sh next

# Select sink (without changing default)
bind = $mainMod, XF86AudioPlay, exec, ~/.config/hypr/scripts/hypr-sink-switcher/audio_sink_switcher.sh select

# Volume Control for Selected Sink
bind = $mainMod, XF86AudioRaiseVolume, exec, ~/.config/hypr/scripts/hypr-sink-switcher/audio_sink_switcher.sh +5%
bind = $mainMod, XF86AudioLowerVolume, exec, ~/.config/hypr/scripts/hypr-sink-switcher/audio_sink_switcher.sh -5%
bind = $mainMod, XF86AudioMute, exec, ~/.config/hypr/scripts/hypr-sink-switcher/audio_sink_switcher.sh mute
```
# 📜 License

This project is licensed under the MIT License.
