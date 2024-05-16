# History
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
if [[ -d ~/.zsh/zsh-syntax-highlighting/ ]]; then
  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [[ -d ~/.zsh/zsh-history-substring-search/ ]]; then
  source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
fi

# Prompt
if command -v starship > /dev/null 2>&1; then
  eval "$(starship init zsh)"
elif [ -f ~/.local/bin/starship ]; then
  eval "$(~/.local/bin/starship init zsh)"
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

alias r='dev node --run'
alias t='dev node --run test'
alias n='pnpm '
alias pui='pnpm update --interactive --latest -r --include-workspace-root'
alias pu='pnpm update -r --include-workspace-root'
alias pui1='pnpm update --interactive --latest'
alias pu1='pnpm update'

export NODE_COMPILE_CACHE=~/.cache/node

if [ -n "$container" ]; then
  alias dev='command'

  # Fix history in container
  HISTFILE=~/.shell-history/histfile
  setopt appendhistory
else
  # Run commands in container
  export PATH="/home/ai/.local/share/node/node_modules/.bin/:$PATH"

  function devcontainer_root() {
    local dir=$PWD
    while [ "$dir" != "/" ]; do
      if [[ -f "$dir/.devcontainer.json" ]] || [[ -d "$dir/.devcontainer" ]]; then
        echo $dir
        return
      fi
      dir=$(dirname "$dir")
    done
    echo "No .devcontainer.json or .devcontainer/ found" >&2
    return 1
  }

  function devcontainer_config() {
    if [[ -f "$1/.devcontainer/podman/devcontainer.json" ]]; then
      echo "$1/.devcontainer/podman/devcontainer.json"
    else
      echo "$1/.devcontainer.json"
    fi
  }

  function dev () {
    local root=$(devcontainer_root)
    local config=$(devcontainer_config $root)
    if [ "$PWD" = "$root" ]; then
      if [ -z "$1" ]; then
        devcontainer exec --docker-path=podman \
          --workspace-folder $root --config $config \
          zsh
      else
        devcontainer exec --docker-path=podman \
          --workspace-folder $root --config $config \
          zsh -ic "$*"
      fi
    else
      local reldir="${PWD#$root/}"
      if [ -z "$1" ]; then
        devcontainer exec --docker-path=podman \
          --workspace-folder $root --config $config \
          zsh -c "cd $reldir; exec zsh"
      else
        devcontainer exec --docker-path=podman \
          --workspace-folder $root --config $config \
          zsh -ic "cd $reldir && $*"
      fi
    fi
  }

  function devup () {
    local root=$(devcontainer_root)
    devcontainer up --docker-path=podman \
      --workspace-folder $root --config $(devcontainer_config $root)
  }

  alias devdown='podman kill --all'

  alias pnpm='dev pnpm'

  alias isolate="\
    cp ~/Dev/environment/devcontainer/devcontainer.json ./.devcontainer.json \
    && echo '.devcontainer.json' >> .git/info/exclude"

  # Disable git hooks
  alias git='~/Dev/environment/bin/no-hooks-git'

  # Fast way to Dev projects
  if [ -d ~/Dev ]; then
    cdpath=(. ~/Dev)
  fi

  # VS Code
  export ELECTRON_TRASH=gio
  alias e='code .'

  # Development
  alias p='dev pnpm clean-publish --temp-dir .npm-release --without-publish \
    && cd .npm-release \
    && npm publish \
    && cd .. \
    && rm -R  .npm-release'

  # Google Cloud
  alias gcloud='sudo --user gcloud gcloud'

  # History
  HISTFILE=~/.histfile
fi
