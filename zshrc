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
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# Prompt
eval "$(starship init zsh)"

# Fast way to Dev projects
if [ -d ~/Dev ]; then
  cdpath=(. ~/Dev)
fi

# Dev tools
if [ -d ~/.asdf/ ]; then
  source ~/.asdf/asdf.sh
  autoload -U +X bashcompinit && bashcompinit
  source ~/.asdf/completions/asdf.bash
fi

# Rip Grep
export RIPGREP_CONFIG_PATH=~/.ripgreprc

# Console editor
export EDITOR=micro

# VS Code
export ELECTRON_TRASH=gio
alias e='code .'

# Aliases
alias g='git'
alias ..='cd ..'
alias l='eza --all'
alias ll='eza --long --all --git'
alias cat='bat --theme=$(gsettings get org.gnome.desktop.interface color-scheme | grep -q "dark" && echo default || echo GitHub)'

# Node.js
alias n='pnpm '
alias pui='pnpm update --interactive --latest -r --include-workspace-root'
alias pu='pnpm update -r --include-workspace-root'
alias ptr='pnpm test -r --include-workspace-root'
alias p='n clean-publish'
alias pui1='pnpm update --interactive --latest'
alias pu1='pnpm update'
alias r='node --run'
alias t='node --run test'
export NODE_COMPILE_CACHE=~/.cache/node

# pnpm
export PNPM_HOME="/home/ai/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Python
export PATH=~/.local/bin/:$PATH

# Lua
export PATH=~/.foreman/bin/:$PATH

# Google Cloud
alias gcloud='sudo --user gcloud gcloud'
