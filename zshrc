# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Key bindings
bindkey -e
bindkey ';5D' backward-word # ctrl+left
bindkey ';5C' forward-word  #ctrl+right

# Completion
zstyle :compinstall filename '/home/ai/.zshrc'
autoload -Uz compinit
compinit

# Zsh plugins
if [ -f ~/.antigen.zsh ]; then
    source ~/.antigen.zsh
    antigen use oh-my-zsh
    antigen bundle per-directory-history
    antigen bundle command-not-found
    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen bundle zsh-users/zsh-history-substring-search
fi

# Fast way to Dev projects
if [ -d ~/Dev ]; then
    cdpath=(. ~/Dev)
fi

# Aliases
alias e='atom .'
alias g='git'
alias ..='cd ..'
alias ll='ls -lh'
alias la='ls -A'

# Prompt
source ~/.prompt.zsh

# Ruby
if [ -d /usr/local/share/chruby/ ]; then
    source /usr/local/share/chruby/chruby.sh
    chruby 2
fi
alias b='bundle exec'

# Node.js
if [ -d ~/.node/ ]; then
    path=(~/.node/node_modules/.bin/ ~/.node/nodejs/bin/ $path)
fi
function n {
    if [ -d "`npm bin`" ]; then
        PROG="$1"
        shift
        "`npm bin`/$PROG" "$@"
    else
        echo 'No node_modules in any dir of current path' 1>&2
        return 1
    fi
}

# Go
export GOPATH=~/.go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
