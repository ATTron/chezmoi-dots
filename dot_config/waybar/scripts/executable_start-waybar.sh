#!/usr/bin/env bash
# Wrapper around waybar. Captures full startup trace to /tmp/waybar.log.
exec >>/tmp/waybar.log 2>&1
echo "--- start-waybar.sh fired at $(date -Iseconds) ---"
echo "WAYLAND_DISPLAY=$WAYLAND_DISPLAY  XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR"
echo "PATH=$PATH"
set -x
sleep 1
exec waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/style.css"
