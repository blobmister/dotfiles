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
	install | i | remove | r | browse | b | browse-installed | bi | update | u)
		command="$arg"
		;;
	*)
		echo "Unknown argument: $arg"
		echo "Usage: parfz [--aur|-a|--all] {install|remove|browse|browse-installed|update}"
		exit 1
		;;
	esac
done

if [[ -z "$command" ]]; then
	echo "Usage: parfz [--aur|-a] {install|remove|browse|browse-installed|update}"
	echo "Example: parfz install"
	echo "Example: parfz --aur update"
	exit 1
fi

case "$command" in
install | i)
	echo "Search and select packages to INSTALL (Use Tab to select multiple)..."
	echo -e "(\033[32mInstalled packages are highlighted in green\033[0m)"

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
	echo -e "(\033[35mAUR packages are highlighted in magenta\033[0m)"

	mapfile -t pkgs < <(
		awk 'NR==FNR { aur[$1]; next } { if ($1 in aur) print "\033[35m" $1 "\033[0m"; else print $1 }' <(pacman -Qmq) <(pacman -Qq) |
			fzf -m --ansi --preview 'pacman -Qi -- {}' |
			sed 's/\x1b\[[0-9;]*m//g'
	)

	if ((${#pkgs[@]})); then
		"$PKG_MGR" -Rns "${pkgs[@]}"
	else
		echo "No packages selected."
	fi
	;;

browse | b)
	echo "Browsing $MODE packages (Esc or Ctrl+C to exit)..."
	echo -e "(\033[32mInstalled packages are highlighted in green\033[0m)"

	"$PKG_MGR" -Sl | awk '{
        if ($0 ~ /\[installed/)
            print "\033[32m" $2 "\033[0m"
        else
            print $2
    }' |
		fzf --ansi --preview "$PKG_MGR -Si -- {}"
	;;

browse-installed | bi)
	echo "Browsing INSTALLED packages (Esc or Ctrl+C to exit)..."
	echo -e "(\033[35mAUR packages are highlighted in magenta\033[0m)"

	awk 'NR==FNR { aur[$1]; next } { if ($1 in aur) print "\033[35m" $1 "\033[0m"; else print $1 }' <(pacman -Qmq) <(pacman -Qq) |
		fzf --ansi --preview 'pacman -Qi -- {}'
	;;

update | u)
	if [[ "$PKG_MGR" == "yay" ]]; then
		echo "Search and select AUR packages to UPDATE (Use Tab to select multiple)..."

		mapfile -t pkgs < <(
			yay -Qua | awk '{print $1, "\033[33m" $2 "\033[0m -> \033[32m" $4 "\033[0m"}' |
				fzf -m --ansi --preview 'yay -Si {1}' |
				awk '{print $1}'
		)

		if ((${#pkgs[@]})); then
			yay -S "${pkgs[@]}"
		else
			echo "No AUR packages selected for update."
		fi
	else
		echo "Performing a standard full system upgrade..."
		echo ""
		sudo pacman -Syu
	fi
	;;
esac
