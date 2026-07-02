#!/usr/bin/env bash
# Per-tag state for waybar custom/tag-N modules. Argv: tag number (1-9).
# mmsg -g -t row format: "<output> tag <N> <selected> <occupied> <focused>"
N=$1
read -r _ _ _ selected occupied focused < <(mmsg -g -t 2>/dev/null | awk -v n="$N" '$3 == n')
selected=${selected:-0}; occupied=${occupied:-0}; focused=${focused:-0}
if   [[ $focused  == 1 ]]; then class=focused
elif [[ $occupied == 1 ]]; then class=occupied
elif [[ $selected == 1 ]]; then class=visible
else                            class=empty; fi
printf '{"text":"%s","class":"%s","alt":"%s"}\n' "$N" "$class" "$class"
