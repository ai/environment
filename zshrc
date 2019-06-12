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
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen bundle zsh-users/zsh-history-substring-search
  antigen theme denysdovhan/spaceship-prompt
  antigen apply
fi

# Prompt
SPACESHIP_PROMPT_ORDER=(time user dir host git exit_code line_sep char)

# Fast way to Dev projects
if [ -d ~/Dev ]; then
  cdpath=(. ~/Dev)
fi

# Rip Grep
export RIPGREP_CONFIG_PATH=~/.ripgreprc

# Atom
export ELECTRON_TRASH=gio
alias e='~/Dev/environment/bin/atom'

# Aliases
alias g='git'
alias ..='cd ..'
alias ll='ls -lh'
alias la='ls -A'

# Ruby
if [ -d /usr/share/chruby/ ]; then
    source /usr/share/chruby/chruby.sh
    chruby 2
fi
alias b='bundle exec'

# Node.js
alias n='npx --no-install'

# Docker
alias d='docker-compose run app'
alias db='docker-compose run app bundle exec'
alias dn='docker-compose run app npx --no-install'
