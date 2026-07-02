#!/usr/bin/env bash
# Power menu via fuzzel — mirrors Noctalia's session menu actions.
set -euo pipefail

options=$(cat <<'EOF'
Lock
Suspend
Reboot
Logout
Shutdown
Hibernate
Reboot to UEFI
EOF
)

choice=$(printf '%s' "$options" | fuzzel --dmenu --prompt='Power: ' --width=24 || true)

case "$choice" in
  "Lock")            ~/.local/bin/lock ;;
  "Suspend")         systemctl suspend ;;
  "Reboot")          systemctl reboot ;;
  "Logout")          mmsg -q ;;
  "Shutdown")        systemctl poweroff ;;
  "Hibernate")       systemctl hibernate ;;
  "Reboot to UEFI")  systemctl reboot --firmware-setup ;;
  *)                 exit 0 ;;
esac
