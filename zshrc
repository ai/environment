# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.local/share/history/histfile
setopt appendhistory
setopt inc_append_history
setopt hist_ignore_all_dups

# Colors
autoload -U colors && colors

# Key bindings
bindkey -e
bindkey ';5D' backward-word # ctrl+left
bindkey ';5C' forward-word  # ctrl+right

# Completion
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit

# Zsh plugins
if [[ -d ~/.local/lib/zsh/zsh-syntax-highlighting/ ]]; then
  source ~/.local/lib/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [[ -d ~/.local/lib/zsh/zsh-autosuggestions/ ]]; then
  source ~/.local/lib/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [[ -d ~/.local/lib/zsh/pnpm-shell-completion/ ]]; then
  source ~/.local/lib/zsh/pnpm-shell-completion/pnpm-shell-completion.plugin.zsh
fi

# Local binaries
export PATH="$HOME/.local/bin/:$PATH"

# Prompt
if command -v starship > /dev/null 2>&1; then
  eval "$(starship init zsh)"
elif [ -f ~/.local/bin/starship ]; then
  eval "$(~/.local/bin/starship init zsh)"
fi

# History
if [ -f ~/.local/bin/atuin ]; then
  eval "$(~/.local/bin/atuin init zsh)"
fi

# Rip Grep
export RIPGREP_CONFIG_PATH=~/.ripgreprc

# Console editor
export EDITOR=micro

# Fix Bat in light console
export BAT_THEME=ansi

# Aliases
alias g='git'
alias ..='cd ..'
alias l='eza --all'
alias ll='eza --long --all --git'

if command -v bat > /dev/null 2>&1; then
  alias cat='bat'
fi
if command -v eza > /dev/null 2>&1; then
  alias ls='eza'
fi

alias r='dev node --disable-warning=ExperimentalWarning --run'
alias t='dev node --disable-warning=ExperimentalWarning --run test'
alias n='pnpm '
alias pui='pnpm update --interactive --latest -r --include-workspace-root'
alias pu='pnpm update -r --include-workspace-root'
alias pui1='pnpm update --interactive --latest'
alias pu1='pnpm update'

export NODE_COMPILE_CACHE=~/.cache/node

if [ -n "$container" ]; then
  alias dev='command'

  if [ -z "$SSH_AUTH_SOCK" ] && [ -S "/run/user/1000/keyring/ssh" ]; then
    export SSH_AUTH_SOCK="/run/user/1000/keyring/ssh"
  fi
else
  # Run commands in container
  export PATH="/home/ai/.local/lib/node/node_modules/.bin/:$PATH"

  alias dev='/home/ai/Dev/environment/bin/dev'
  alias devup='dev --up'
  alias devdown='dev --down'
  alias pnpm='dev pnpm'
  alias node='dev node'
  alias pinact='dev pinact'

  # Run git hooks inside Dev Container
  export GIT_CONFIG_PARAMETERS="'core.hooksPath=/home/ai/Dev/environment/hooks-trap'"

  # Fast way to Dev projects
  if [ -d ~/Dev ]; then
    cdpath=(. ~/Dev)
  fi

  # VS Code
  alias e='~/Dev/environment/bin/zed-isolate .'

  # Development
  alias release=~/Dev/environment/bin/release
  alias p='dev pnpm clean-publish --temp-dir .npm-release --without-publish \
    && cd .npm-release \
    && npm publish \
    && cd .. \
    && rm -R  .npm-release'

  # Google Cloud
  alias gcloud='sudo --user gcloud gcloud'
  alias gsutil='sudo --user gcloud gsutil'
fi
