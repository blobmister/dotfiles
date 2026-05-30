#!/usr/bin/env bash

desktop_files=$(find /usr/share/applications ~/.local/share/applications -maxdepth 2 -name "*.desktop" 2>/dev/null | awk -F/ '{print $NF}' | sed 's/\.desktop$//' | sort -u)

chosen=$(echo "$desktop_files" | fzf --no-hscroll --reverse --prompt="Run: ")

if [[ -n "$chosen" ]]; then
    gtk-launch "$chosen" &
fi
