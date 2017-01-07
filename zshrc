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
  source ~/.antigen.zsh
  antigen bundle yarn
  antigen bundle per-directory-history
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

# Ruby
alias b='bundle exec'
if [ -d ~/.gem/ruby/bin ]; then
  PATH="$PATH:/home/ai/.gem/ruby/bin/"
fi

# Node.js
function n {
  if [ -d "`yarn bin`" ]; then
    PROG="$1"
    shift
    "`yarn bin`/$PROG" "$@"
  else
    echo 'No node_modules in any dir of current path' 1>&2
    return 1
  fi
}
