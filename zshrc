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
