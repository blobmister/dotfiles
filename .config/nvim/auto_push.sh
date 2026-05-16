#!bin/bash

config() {
	/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
}

config add init.lua
config commit -m "inti.lua CHANGED"
config push
