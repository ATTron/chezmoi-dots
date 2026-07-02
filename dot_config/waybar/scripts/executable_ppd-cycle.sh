#!/usr/bin/env bash
# Cycle power-profiles-daemon profile and notify.
set -euo pipefail
case "$(powerprofilesctl get)" in
  performance) next=power-saver ;;
  power-saver) next=balanced ;;
  *)           next=performance ;;
esac
powerprofilesctl set "$next"
notify-send -t 2500 "Power profile" "$next"
