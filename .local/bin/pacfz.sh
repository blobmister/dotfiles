#!/usr/bin/env bash

export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --border --preview-window=right:50%:wrap'

PKG_MGR="pacman"
MODE="Official"

command=""
for arg in "$@"; do
	case "$arg" in
	--aur | -a | --all)
		PKG_MGR="yay"
		MODE="Official + AUR"
		;;
	install | i | remove | r | browse | b)
		command="$arg"
		;;
	*)
		echo "Unknown argument: $arg"
		echo "Usage: parfz [--aur|-a|--all] {install|remove|browse}"
		exit 1
		;;
	esac
done

if [[ -z "$command" ]]; then
	echo "Usage: parfz [--aur|-a] {install|remove|browse}"
	echo "Example: parfz install"
	echo "Example: parfz --aur install"
	exit 1
fi

case "$command" in
install | i)
	echo "Search and select packages to INSTALL (Use Tab to select multiple)..."

	mapfile -t pkgs < <(
		"$PKG_MGR" -Sl | awk '{
            if ($0 ~ /\[installed/)
                print "\033[32m" $2 "\033[0m"
            else
                print $2
        }' |
			fzf -m --ansi --preview "$PKG_MGR -Si -- {}" |
			sed 's/\x1b\[[0-9;]*m//g'
	)

	if ((${#pkgs[@]})); then
		"$PKG_MGR" -S "${pkgs[@]}"
	else
		echo "No packages selected."
	fi
	;;

remove | r)
	echo "Search and select packages to REMOVE (Use Tab to select multiple)..."

	mapfile -t pkgs < <(
		pacman -Qq |
			fzf -m --preview 'pacman -Qi -- {}'
	)

	if ((${#pkgs[@]})); then
		"$PKG_MGR" -Rns "${pkgs[@]}"
	else
		echo "No packages selected."
	fi
	;;

browse | b)
	echo "Browsing $MODE packages (Esc or Ctrl+C to exit)..."

	"$PKG_MGR" -Sl | awk '{
        if ($0 ~ /\[installed/)
            print "\033[32m" $2 "\033[0m"
        else
            print $2
    }' |
		fzf --ansi --preview "$PKG_MGR -Si -- {}"
	;;
esac
