#!/usr/bin/env bash

FZF_DEFAULT_OPTS="--height 80% --layout=reverse --border --preview-window=right:50%:wrap"

case "$1" in
install | i)
	echo "Search and select packages to INSTALL (Use Tab to select multiple)..."
	pkgs=$(paru -Slq | fzf -m --preview 'paru -Si {}')

	if [[ -n "$pkgs" ]]; then
		paru -S $(echo "$pkgs" | tr '\n' ' ')
	else
		echo "No packages selected."
	fi
	;;

remove | r)
	echo "Search and select packages to REMOVE (Use Tab to select multiple)..."
	pkgs=$(paru -Qq | fzf -m --preview 'paru -Qi {}')

	if [[ -n "$pkgs" ]]; then
		paru -Rns $(echo "$pkgs" | tr '\n' ' ')
	else
		echo "No packages selected."
	fi
	;;

browse | b)
	echo "Browsing all packages (Esc or Ctrl+C to exit)..."
	paru -Slq | fzf --preview 'paru -Si {}'
	;;

*)
	echo "Usage: parfz {install|remove|browse} or {i|r|b}"
	echo "Example: parfz install"
	exit 1
	;;
esac
