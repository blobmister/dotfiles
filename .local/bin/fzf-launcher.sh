#!/usr/bin/env bash


if [ ! -t 1 ]; then
    exec kitty --class="fzf-launcher" \
               --title="App Launcher" \
               -o window_padding_width=20 \
               -o hide_window_decorations=yes \
               -o remember_window_size=no \
               -o initial_window_width=650 \
               -o initial_window_height=400 \
               bash -c "$0"
    exit
fi

desktop_files=$(find /usr/share/applications ~/.local/share/applications -maxdepth 2 -name "*.desktop" 2>/dev/null | awk -F/ '{print $NF}' | sed 's/\.desktop$//' | sort -u)

chosen=$(echo "$desktop_files" | fzf --no-hscroll \
                                     --reverse \
                                     --prompt="🔍 Run:  " \
                                     --border=none \
                                     --info=hidden \
                                     --margin=1,2)


if [[ -n "$chosen" ]]; then
    setsid gtk-launch "$chosen" >/dev/null 2>&1 &
    sleep 0.1
fi
