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

# VS Code
export ELECTRON_TRASH=gio
alias e='code .'

# Aliases
alias g='git'
alias ..='cd ..'
alias l='exa --all'
alias ll='exa --long --all --git'

# Dev Tools
. $HOME/.asdf/asdf.sh

# Node.js
alias n='npx --no-install'
alias yui='yarn upgrade-interactive --latest'
alias yu='yarn upgrade'
alias p='dos2unix node_modules/clean-publish/clean-publish.js && n clean-publish'
alias j="NODE_OPTIONS=--experimental-vm-modules npx jest"

# Python
export PATH=~/.local/bin/:$PATH

# Fix mpv
export MESA_LOADER_DRIVER_OVERRIDE=i965
