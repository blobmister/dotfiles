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

fzf_output=$(echo "$desktop_files" | fzf --no-hscroll \
                                         --reverse \
                                         --prompt="> " \
                                         --border=none \
                                         --info=hidden \
                                         --margin=1,2 \
                                         --print-query)

query=$(echo "$fzf_output" | head -n 1)
selection=$(echo "$fzf_output" | sed -n '2p')

if [[ "$query" =~ ^g\ +(.*) ]]; then
    search_terms="${BASH_REMATCH[1]}"
    search_string=$(echo "$search_terms" | tr ' ' '+')
    setsid xdg-open "https://www.google.com/search?q=${search_string}" >/dev/null 2>&1 &
    sleep 0.1

elif [[ -n "$selection" ]] && echo "$desktop_files" | grep -qxF "$selection"; then
    setsid gtk-launch "$selection" >/dev/null 2>&1 &
    sleep 0.1

elif [[ -n "$query" ]] && echo "$desktop_files" | grep -qxF "$query"; then
    setsid gtk-launch "$query" >/dev/null 2>&1 &
    sleep 0.1
fi
