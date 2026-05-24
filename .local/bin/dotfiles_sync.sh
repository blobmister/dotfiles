#!/bin/bash

dotfiles() {
	/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
}

if ! dotfiles diff --quiet; then
	dotfiles pull
	dotfiles add -u
	CURRENT_DATE=$(date '+%Y-%m-%d %H:%M:%S')
	dotfiles commit -m "Auto-sync dotfiles: $CURRENT_DATE"
	dotfiles push origin main
fi
