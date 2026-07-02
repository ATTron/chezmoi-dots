#!/usr/bin/env bash
# Combined battery + power-profile module for waybar (return-type: json).
set -euo pipefail

# --- battery state -----------------------------------------------------------
BAT_DIR=$(ls -d /sys/class/power_supply/BAT* 2>/dev/null | head -1 || true)
if [[ -z "$BAT_DIR" ]]; then
  printf '{"text":"","tooltip":"no battery","class":"none"}\n'
  exit 0
fi
cap=$(<"$BAT_DIR/capacity")
status=$(<"$BAT_DIR/status")

# Tabler glyphs (loaded via noctalia-tabler-icons font)
G_BAT_1=$''   G_BAT_2=$''   G_BAT_3=$''   G_BAT_4=$''
G_CHARGING=$''
G_PERF=$''    G_BAL=$''     G_SAVE=$''

if [[ "$status" == "Charging" || "$status" == "Full" ]]; then
  bat_icon=$G_CHARGING
elif (( cap < 25 )); then bat_icon=$G_BAT_1
elif (( cap < 50 )); then bat_icon=$G_BAT_2
elif (( cap < 75 )); then bat_icon=$G_BAT_3
else                       bat_icon=$G_BAT_4
fi

# --- power profile -----------------------------------------------------------
ppd=$(powerprofilesctl get 2>/dev/null || echo "balanced")
case "$ppd" in
  performance) ppd_icon=$G_PERF ;;
  power-saver) ppd_icon=$G_SAVE ;;
  *)           ppd_icon=$G_BAL  ;;
esac

# --- urgency class -----------------------------------------------------------
if   (( cap < 10 )); then class=critical
elif (( cap < 25 )); then class=warning
else                      class=normal
fi

# --- emit JSON ---------------------------------------------------------------
text="${bat_icon}  ${cap}%  ${ppd_icon}"
tooltip="Battery: ${cap}% (${status})\nPower profile: ${ppd}"
printf '{"text":"%s","tooltip":"%s","class":"%s","alt":"%s"}\n' "$text" "$tooltip" "$class" "$ppd"
