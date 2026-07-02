#!/usr/bin/env bash
# Watches mango tag changes and signals waybar to refresh tag modules (RTMIN+8).
mmsg -w -t 2>/dev/null | while read -r _; do
  pkill -RTMIN+8 waybar 2>/dev/null
done
