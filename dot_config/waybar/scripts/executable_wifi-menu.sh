#!/usr/bin/env bash
# Wifi picker via fuzzel + nmcli. Bound to network module on-click in waybar.
set -euo pipefail

iface=wlan0

# Scan + list: "<* | spaces><ssid> (<signal>%)< [lock]>"
mapfile -t networks < <(
  nmcli -t -f IN-USE,SSID,SIGNAL,SECURITY device wifi list --rescan auto 2>/dev/null \
    | awk -F: '$2 != "" {
        mark = ($1 == "*") ? "* " : "  "
        sec  = ($4 != "" && $4 != "--") ? " [lock]" : ""
        printf "%s%s (%s%%)%s\n", mark, $2, $3, sec
      }' \
    | awk '!seen[$0]++'
)

radio_state=$(nmcli radio wifi 2>/dev/null || echo unknown)
actions=(
  "---"
  "Toggle wifi (currently: $radio_state)"
  "Disconnect"
  "Open nmtui"
)

choice=$(printf '%s\n' "${networks[@]}" "${actions[@]}" \
  | fuzzel --dmenu --prompt='Wifi: ' --width=40 || true)

notify() { command -v notify-send >/dev/null && notify-send -t 3000 "Wifi" "$1" || true; }

case "$choice" in
  ""|"---") exit 0 ;;
  "Toggle wifi"*)
    [[ "$radio_state" == "enabled" ]] && nmcli radio wifi off || nmcli radio wifi on
    ;;
  "Disconnect")
    nmcli device disconnect "$iface" && notify "Disconnected" || notify "Disconnect failed"
    ;;
  "Open nmtui")
    foot -e nmtui &
    ;;
  *)
    ssid=$(echo "$choice" | sed -E 's/^(\* |  )//; s/ \([0-9]+%\)( \[lock\])?$//')

    # First attempt: let NM use whatever it already knows. Captures stderr so we
    # can detect the "Secrets required" case without ever prompting if NM has the password.
    err=$(nmcli device wifi connect "$ssid" 2>&1 >/dev/null) && {
      notify "Connected to $ssid"
      exit 0
    }
    if [[ "$err" == *"Secrets were required"* || "$err" == *"802-11-wireless-security"* ]]; then
      pw=$(fuzzel --dmenu --password --prompt="Password for $ssid: " || true)
      [[ -z "$pw" ]] && exit 0
      nmcli device wifi connect "$ssid" password "$pw" >/dev/null 2>&1 \
        && notify "Connected to $ssid" \
        || notify "Failed to connect to $ssid"
    else
      notify "Failed: ${err##*: }"
    fi
    ;;
esac
