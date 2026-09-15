#!/usr/bin/env bash


target=$(tmux list-sessions -F "#{session_name}" | fzf)
if [[ -n $target ]]; then
    tmux switch-client -t "$target"
fi
