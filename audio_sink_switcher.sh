#!/bin/bash

# File where the selected sink (for volume control) is stored
SINK_FILE="$(dirname "$0")/selected_sink"

# Icon directory from volume.sh
iDIR="$HOME/.config/swaync/icons"

# Get the friendly (human-readable) name for a sink ID
friendly_name() {
    pactl list sinks | awk -v sink="$1" '
        $1=="Name:" && $2==sink {found=1}
        found && $1=="Description:" {
            $1=""; sub(/^ /, ""); print; exit
        }'
}


# Get the stored sink id (or fallback to the system default)
get_selected_sink() {
    if [[ -f "$SINK_FILE" ]]; then
        cat "$SINK_FILE"
    else
        pactl info | grep "Default Sink" | awk '{print $3}'
    fi
}

# Save the selected sink id
save_selected_sink() {
    echo "$1" > "$SINK_FILE"
}

# Detect available launcher (rofi, wofi, or fuzzel)
detect_launcher() {
    if [[ -n "$WAYLAND_DISPLAY" ]] || [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
        if command -v wofi &> /dev/null; then
            echo "wofi --dmenu -p 'Select Audio Sink'"
            return
        fi
    fi
    if command -v rofi &> /dev/null; then
        echo "rofi -dmenu -p 'Select Audio Sink'"
        return
    fi
    if command -v fuzzel &> /dev/null; then
        echo "fuzzel"
        return
    fi
    echo ""
}

LAUNCHER=$(detect_launcher)
if [[ -z "$LAUNCHER" ]]; then
    echo "Error: No compatible launcher found (install rofi, wofi, or fuzzel)." >&2
    exit 1
fi

select_sink() {
    declare -A sink_map
    local friendly_list="" current friendly_line chosen sink_id

    current=$(get_selected_sink)

    while read -r line; do
        sink=$(echo "$line" | awk '{print $2}')
        friendly=$(friendly_name "$sink")
        [[ -z "$friendly" ]] && friendly="$sink"
        sink_map["$friendly"]="$sink"
        if [[ "$sink" == "$current" ]]; then
            friendly_list+="* $friendly"$'\n'
        else
            friendly_list+="  $friendly"$'\n'
        fi
    done < <(pactl list sinks short)

    chosen=$(echo -e "$friendly_list" | eval "$LAUNCHER" | sed 's/^[* ]*//')
    if [[ -n "$chosen" ]]; then
        sink_id="${sink_map[$chosen]}"
        if [[ -n "$sink_id" ]]; then
            save_selected_sink "$sink_id"
            notify_custom "$(friendly_name "$sink_id")" "Selected"
        else
            notify "Error: Could not find sink ID for $chosen"
        fi
    else
        notify "No sink selected"
    fi
}

cycle_sink() {
    local direction="$1"
    local sinks current index new_index new_sink
    sinks=($(pactl list sinks short | awk '{print $2}'))
    current=$(pactl info | grep "Default Sink" | awk '{print $3}')
    index=-1
    for i in "${!sinks[@]}"; do
        if [[ "${sinks[$i]}" == "$current" ]]; then
            index=$i
            break
        fi
    done
    if [[ $index -ge 0 ]]; then
        if [[ "$direction" == "next" ]]; then
            new_index=$(( (index + 1) % ${#sinks[@]} ))
        else
            new_index=$(( (index - 1 + ${#sinks[@]}) % ${#sinks[@]} ))
        fi
        new_sink="${sinks[$new_index]}"
        pactl set-default-sink "$new_sink"
        notify_custom "$(friendly_name "$new_sink")" "Default Sink Set"
    else
        notify "No default sink found"
    fi
}

# Get Volume
get_volume() {
    volume=$(pactl get-sink-volume "$(get_selected_sink)" | awk 'NR==1 {print $5}')
    if [[ "$volume" == "0%" ]]; then
        echo "Muted"
    else
        echo "${volume%\%}"
    fi
}

# Get icons
get_icon() {
    current=$(get_volume)
    if [[ "$current" == "Muted" ]]; then
        echo "$iDIR/volume-mute.png"
    elif [[ "$current" -le 30 ]]; then
        echo "$iDIR/volume-low.png"
    elif [[ "$current" -le 60 ]]; then
        echo "$iDIR/volume-mid.png"
    else
        echo "$iDIR/volume-high.png"
    fi
}

# Notify
# Notify
# Notify
notify_custom() {
    local sink_name="$1"
    local message="$2"
    local volume=$(get_volume)
    local icon=$(get_icon)

     if [[ "$volume" == "Muted" ]]; then
        notify-send -e -h string:x-canonical-private-synchronous:volume_notif -u low -i "$icon" " $sink_name:" " Muted"
    else
        notify-send -e -h int:value:"$volume" -h string:x-canonical-private-synchronous:volume_notif -u low -i "$icon" " $sink_name:" " $message: $volume%"
    fi
}
change_volume() {
    local selected_sink new_vol
    selected_sink=$(get_selected_sink)
    if [[ -z "$selected_sink" ]]; then
        notify "No sink selected. Run '$0 select' first."
        exit 1
    fi
    pactl set-sink-volume "$selected_sink" "$1"
    notify_custom "$(friendly_name "$selected_sink")" "Volume Change"
}

toggle_mute() {
    local selected_sink mute_state
    selected_sink=$(get_selected_sink)
    if [[ -z "$selected_sink" ]]; then
        notify "No sink selected. Run '$0 select' first."
        exit 1
    fi
    pactl set-sink-mute "$selected_sink" toggle
    mute_state=$(pactl get-sink-mute "$selected_sink" | awk '{print $2}')
    if [[ "$mute_state" == "yes" ]]; then
        notify_custom "$(friendly_name "$selected_sink")" "Muted"
    else
        notify_custom "$(friendly_name "$selected_sink")" "Unmuted"
    fi
}

apply_sink() {
    local selected_sink fname option
    selected_sink=$(get_selected_sink)
    if [[ -z "$selected_sink" ]]; then
        notify "No sink selected. Run '$0 select' first."
        exit 1
    fi
    fname=$(friendly_name "$selected_sink")
    option=$(echo -e "Set as Default\nCancel" | rofi -dmenu -p "Apply sink: $fname")
    if [[ "$option" == "Set as Default" ]]; then
        pactl set-default-sink "$selected_sink"
        notify_custom "$fname" "Default Sink Set"
    else
        notify "Action cancelled"
    fi
}

case "$1" in
    "select") select_sink ;;
    "next") cycle_sink "next" ;;
    "prev") cycle_sink "prev" ;;
    "mute") toggle_mute ;;
    "+5%") change_volume "+5%" ;;
    "-5%") change_volume "-5%" ;;
    "apply") apply_sink ;;
    *) echo "Usage: $0 {select|next|prev|mute|+5%|-5%|apply}" ;;
esac
