
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \w]\$ '

export EDTOR=nvim

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'


# Enables brew if it exists
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
fi

alias ts='~/.local/bin/tmux-sessionizer.sh'
alias dotsync='~/.local/bin/dotfiles_sync.sh'
alias fzflaunch='~/.local/bin/fzf-launcher.sh'

# add nvcc to path if it exists
if [ -d "/usr/local/cuda/bin" ]; then
    export PATH="/usr/local/cuda/bin${PATH:+:${PATH}}"
    export LD_LIBRARY_PATH="/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
fi

