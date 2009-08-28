[ -z "$PS1" ] && return

export HISTCONTROL=ignoredups
shopt -s histappend

shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

PS1='\[\e[0;34m\]\w\[\e[0m\]\$ '
if [ "$SSH_CLIENT" ]; then
    PS1="\h $PS1"
fi

PATH="$PATH:~/Скрипты:~/.gems/bin/"

CDPATH='.:~/Разработка'

export GEM_HOME=/home/ai/.gems

eval "`dircolors -b`"
alias ls='ls --color=auto'
alias grep='grep --color=auto'

if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
complete -C ~/Скрипты/rake_autocomplete -o default rake

alias ll='ls -lh'
alias la='ls -A'
alias ps?='ps -A | grep '
alias ..='cd ..'
alias св='cd'

alias rake='ruby ~/.gems/bin/rake'
alias rake1.9='ruby1.9 ~/.gems/bin/rake'
alias rake?='rake -T'
alias rake1.9?='rake1.9 -T'

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'
