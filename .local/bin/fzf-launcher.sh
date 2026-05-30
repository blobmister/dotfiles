#!/usr/bin/env bash

LAUNCHER_CLASS="fzf-launcher"
LOCK_FILE="/dev/shm/fzf-launcher.lock"

if [ ! -t 1 ]; then
    if ! flock -n "$LOCK_FILE" true; then
        TARGET_PID=$(cat "$LOCK_FILE" 2>/dev/null)
        if [ -n "$TARGET_PID" ]; then
            kill "$TARGET_PID" 2>/dev/null
        fi
        exit 0
    fi
fi

if [ ! -t 1 ]; then
    flock -n "$LOCK_FILE" -c "
        alacritty --class '$LAUNCHER_CLASS','$LAUNCHER_CLASS' \
                  --title 'App Launcher' \
                  -o 'window.padding={x=20, y=20}' \
                  -o 'window.decorations=None' \
                  -o 'window.dimensions={columns=80, lines=15}' \
                  -e bash -c '$0' &
        echo \$! > '$LOCK_FILE'
        wait \$! 2>/dev/null
    "
    exit 0
fi

desktop_files=$(find /usr/share/applications ~/.local/share/applications -maxdepth 2 -name "*.desktop" 2>/dev/null | awk -F/ '{print $NF}' | sed 's/\.desktop$//' | sort -u)

chosen=$(echo "$desktop_files" | fzf --no-hscroll \
                                     --reverse \
                                     --prompt=">  " \
                                     --border=none \
                                     --info=hidden \
                                     --margin=1,2)

if [[ -n "$chosen" ]]; then
    setsid gtk-launch "$chosen" >/dev/null 2>&1 &
    sleep 0.1
fi
