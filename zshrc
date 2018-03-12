# History
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# Colors
autoload -U colors && colors

# Key bindings
bindkey -e
bindkey ';5D' backward-word # ctrl+left
bindkey ';5C' forward-word  # ctrl+right

# Completion
zstyle :compinstall filename '/home/ai/.zshrc'
autoload -Uz compinit
compinit

# Zsh plugins
if [ -f ~/.antigen.zsh ]; then
  ANTIGEN_MUTEX=false
  source ~/.antigen.zsh
  antigen bundle yarn
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen bundle zsh-users/zsh-history-substring-search
fi

# Prompt
source ~/.prompt/async.zsh
source ~/.prompt/main.zsh

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
source ~/.aliases.zsh

# Ruby
if [ -d /usr/local/share/chruby/ ]; then
    source /usr/local/share/chruby/chruby.sh
    chruby 2
fi
alias b='bundle exec'

# Node.js
alias n='npx'

# Go

GOPATH=.go/
PATH=$PATH:$GOPATH/bin
