#!bin/bash

dotfiles() {
	/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
}

if ! dotfiles diff --quiet; then
	config add -u
	config commit -m "Auto-sync dotfiles script running: $(date + %Y-%m-%d %H:%M:%S)"
	config push origin main
fi
