#!/usr/bin/env bash

iDIR="$HOME/.config/mako/icons"

# Get audio
get_audio() {
	echo $(pactl get-sink-volume @DEFAULT_SINK@ | grep '^Volume:' | cut -d / -f 2 | tr -d ' ' | sed 's/%//')
}

# Get muted
get_muted() {
	echo $(pactl get-sink-mute @DEFAULT_SINK@ | awk -F ': ' '{print $2}')
}

# Get icons
get_icon() {
	is_muted=$(get_muted)
	current=$(get_audio)
	if [[ ("$current" -eq "0") ]] || [[ ("$is_muted" == "yes") ]]; then
		echo "$iDIR/volume-mute.png"
	elif [[ ("$current" -ge "0") && ("$current" -le "30") ]]; then
		echo "$iDIR/volume-low.png"
	elif [[ ("$current" -ge "30") && ("$current" -le "60") ]]; then
		echo "$iDIR/volume-mid.png"
	else
		echo "$iDIR/volume-high.png"
	fi
}

# Notify
notify_user() {
	notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Sound : $current%"
}

# Notify on mute
notify_user_mute() {
	is_muted=$(get_muted)
	if [[ ("$is_muted"  == "yes") ]]; then
		notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Muted"
	else
		current=$(get_audio)
		notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -i "$(get_icon)" "Sound : $current%"
	fi
}

# Change audio
change_audio() {
	is_muted=$(get_muted)
	if [[ ("$is_muted"  == "yes") ]]; then
		pactl set-sink-mute @DEFAULT_SINK@ toggle
	fi
	pactl set-sink-volume @DEFAULT_SINK@ $1 && get_icon && notify_user
}

# Mute audio
mute_audio() {
	pactl set-sink-mute @DEFAULT_SINK@ toggle && notify_user_mute
}

# Execute accordingly
case "$1" in
"--mute")
	mute_audio
	;;
"--inc")
	change_audio "+5%"
	;;
"--dec")
	change_audio "-5%"
	;;
*)
	get_audio
	;;
esac
