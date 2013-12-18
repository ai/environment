# Системные настройки

export HISTCONTROL=ignoredups
shopt -s histappend

shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

TERM=xterm-256color

# Запрос новой команды

if [ -d /usr/share/git-core/contrib/completion/ ]; then
    . /usr/share/git-core/contrib/completion/git-prompt.sh
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
else
    format_git_branch() {
        echo ""
    }
fi

prompt_dir() {
    echo "$PWD" | sed -r "s|^/home/$USER|~|g" | sed -r "s|^~/Dev/||g"
}

function prompt() {
    exitstatus=$?

    BLUE="\[\e[0;34m\]"
    RED="\[\e[0;31m\]"
    OFF="\[\e[0m\]"

    PS1="\$(prompt_dir)"

    if [ $exitstatus -eq 0 ]; then
        PS1="${BLUE}${PS1}${OFF}"
    else
        PS1="${RED}${PS1}${OFF}"
    fi
    if [ "$SSH_CLIENT" ]; then
        PS1="\h $PS1 ➜ "
    else
        PS1="$PS1\$(format_git_branch) → "
    fi
}
PROMPT_COMMAND=prompt

# Цветной вывод основных команд

eval "`dircolors -b`"
LS_COLORS=""
alias ls='ls --color=auto'
alias grep='grep --color=auto'

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Автозавершение

if [ -f /etc/profile.d/bash_completion.sh ]; then
    . /etc/profile.d/bash_completion.sh
fi

if [ -d ~/Скрипты ]; then PATH="$PATH:~/Скрипты"; fi
if [ -d ~/Dev ];     then CDPATH='.:~/Dev'; fi

# Алиасы

alias g='git'
alias ll='ls -lh'
alias la='ls -A'
alias ps?='ps -A | grep '
alias hosts='sudo nano /etc/hosts'
alias e='sublime_text ./'

function .. {
  for i in `seq ${1-1}`; do
    cd ..;
  done
}

# Ruby

alias b='bundle exec'
alias ruby1.9.1='ruby'

if [ -d /usr/local/share/chruby/ ]; then
    source /usr/local/share/chruby/chruby.sh
    source /usr/local/share/chruby/auto.sh
    chruby 2.0
fi

# Ускоряем запуск JRuby

JRUBY_OPTS='-J-Xmx1024m -J-Xms1024m -J-XX:MaxPermSize=256m -J-XX:PermSize=256m
            -Xcompile.invokedynamic=false -J-XX:+TieredCompilation
            -J-XX:TieredStopAtLevel=1'

# Node.js

function n {
    if [ -d `npm bin` ]; then
        PROG="$1"
        shift
        `npm bin`/$PROG "$@"
    else
        echo 'No node_modules in any dir of current path' 1>&2
        return 1
    fi
}

# Редактор по умолчанию

EDITOR=nano
