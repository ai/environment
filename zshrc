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

# Zsh plugins
if [ -f ~/.antigen.zsh ]; then
  ANTIGEN_MUTEX=false
  source ~/.antigen.zsh
  antigen bundle zsh-users/zsh-syntax-highlighting
  antigen bundle zsh-users/zsh-history-substring-search
  antigen theme denysdovhan/spaceship-prompt
  antigen bundle zsh-users/zsh-completions
  antigen apply
fi

# Completion
zstyle :compinstall filename '/home/ai/.zshrc'
autoload -Uz compinit
compinit

# Prompt
SPACESHIP_PROMPT_ORDER=(time user dir host git exit_code line_sep char)

# Fast way to Dev projects
if [ -d ~/Dev ]; then
  cdpath=(. ~/Dev)
fi

# Dev tools
if [ -d ~/.asdf/ ]; then
  source $HOME/.asdf/asdf.sh
  autoload -U +X bashcompinit && bashcompinit
  source $HOME/.asdf/completions/asdf.bash
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

# Node.js
alias n='pnpx --no-install'
alias yui='yarn upgrade-interactive --latest'
alias yu='yarn upgrade'
alias pui='pnpm update --interactive --latest'
alias pu='pnpm update'
alias p='n clean-publish'

# pnpm
if [ -f ~/.config/tabtab/zsh/pnpm.zsh ]; then
  source ~/.config/tabtab/zsh/pnpm.zsh
fi

# Python
export PATH=~/.local/bin/:$PATH

# Fix mpv
export MESA_LOADER_DRIVER_OVERRIDE=i965
