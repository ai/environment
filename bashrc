export HISTCONTROL=ignoredups
shopt -s histappend

shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

TERM=xterm-256color

format_git_branch() {
    if [ -n "$(__gitdir)" ]; then
        if [ "`git stash list`" ]; then
            local stash=" (s`git stash list | wc -l`)"
        fi
        local branch=`git current-branch`
        if [ "$branch" -a "$branch" != 'master' ]; then
            echo " $branch$stash"
        else
            echo "$stash"
        fi
    fi
}

PS1="\[\e[0;34m\]\w\[\e[0m\]"
if [ "$SSH_CLIENT" ]; then
    PS1="\h $PS1 ➜ "
else
    PS1="$PS1\$(format_git_branch) ➜ "
fi

eval "`dircolors -b`"
alias ls='ls --color=auto'
alias grep='grep --color=auto'

if [ -f /etc/bash_completion ]; then . /etc/bash_completion; fi

if [ -d ~/Скрипты ]; then PATH="$PATH:~/Скрипты"; fi
if [ -d ~/Dev ]; then CDPATH='.:~/Dev'; fi


alias ll='ls -lh'
alias la='ls -A'
alias ps?='ps -A | grep '
alias ..='cd ..'
alias hosts='sudo nano /etc/hosts'

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

if [ -d ~/.gem/ ]; then
    alias rake1.9.1='~/.gem/ruby/1.9.1/bin/rake'
    PATH="$PATH:~/.gem/ruby/1.8/bin:~/.gem/ruby/1.9.1/bin"
    alias bundle='~/.gem/ruby/1.8/bin/bundle'
    alias bundle9='~/.gem/ruby/1.9.1/bin/bundle'
    alias b8='bundle exec'
    alias b9='bundle9 exec'
fi
