#!/usr/bin/env bash

export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --border --preview-window=right:50%:wrap'

case "$1" in
install | i)
	echo "Search and select packages to INSTALL (Use Tab to select multiple)..."

	mapfile -t pkgs < <(
		yay -Slq |
			fzf -m --preview 'yay -Si -- {}'
	)

	if ((${#pkgs[@]})); then
		yay -S "${pkgs[@]}"
	else
		echo "No packages selected."
	fi
	;;

remove | r)
	echo "Search and select packages to REMOVE (Use Tab to select multiple)..."

	mapfile -t pkgs < <(
		yay -Qq |
			fzf -m --preview 'yay -Qi -- {}'
	)

	if ((${#pkgs[@]})); then
		yay -Rns "${pkgs[@]}"
	else
		echo "No packages selected."
	fi
	;;

browse | b)
	echo "Browsing official packages (Esc or Ctrl+C to exit)..."

	yay -Slq |
		fzf --preview 'yay -Si -- {}'
	;;

*)
	echo "Usage: parfz {install|remove|browse} or {i|r|b}"
	echo "Example: parfz install"
	exit 1
	;;
esac
