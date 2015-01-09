# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Key bindings
bindkey -e

# Completion
zstyle :compinstall filename '/home/ai/.zshrc'
autoload -Uz compinit
compinit

# Fast way to Dev projects
if [ -d ~/Dev ]; then
    cdpath=(. ~/Dev)
fi

# Aliases
alias e='atom .'
alias g='git'
alias ll='ls -lh'
alias la='ls -A'

# Ruby
if [ -d /usr/local/share/chruby/ ]; then
    source /usr/local/share/chruby/chruby.sh
    chruby 2
fi
alias b='bundle exec'

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
