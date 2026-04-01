#!/bin/sh
# Mango autostart — mirrors niri spawn-at-startup

# Cursor theme
export XCURSOR_THEME="Simp1e-Gruvbox-Dark"
export XCURSOR_SIZE=24

# Shell
qs -c noctalia-shell &

# Wallpaper
swaybg -i /home/korra/.walls/bebop_wall2_cropped.png &

# Idle: lock after 900s, monitors off after 1600s, lock before sleep
swayidle -w \
    timeout 900 'qs -c noctalia-shell ipc call lockScreen lock' \
    timeout 1600 "wlopm --off '*'" \
    resume "wlopm --on '*'" \
    before-sleep 'qs -c noctalia-shell ipc call lockScreen lock' &
