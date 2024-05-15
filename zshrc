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
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh

# Prompt
eval "$(starship init zsh)"

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
alias cat='bat'
alias ls='eza'

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

  function find_devcontainer_dir() {
    local dir=$PWD
    while [ "$dir" != "/" ]; do
      if [[ -f "$dir/.devcontainer.json" ]]; then
        echo $dir
        return
      fi
      dir=$(dirname "$dir")
    done
    echo "No .devcontainer.json found in any parent directories." >&2
    return 1
  }

  alias devup='devcontainer up --docker-path=podman --workspace-folder $(find_devcontainer_dir)'
  alias devdown='podman kill --all'

  function dev () {
    local root=$(find_devcontainer_dir)
    if [ "$PWD" = "$root" ]; then
      if [ -z "$1" ]; then
        devcontainer exec --docker-path=podman --workspace-folder $root zsh
      else
        devcontainer exec --docker-path=podman --workspace-folder $root \
          zsh -ic "$*"
      fi
    else
      local reldir="${PWD#$root/}"
      if [ -z "$1" ]; then
        devcontainer exec --docker-path=podman --workspace-folder $root \
          zsh -c "cd $reldir; exec zsh"
      else
        devcontainer exec --docker-path=podman --workspace-folder $root \
          zsh -ic "cd $reldir && $*"
      fi
    fi
  }

  alias pnpm='dev pnpm'

  alias isolate="cp ~/Dev/environment/devcontainer/devcontainer.json ./.devcontainer.json && echo '.devcontainer.json' >> .git/info/exclude"

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
  alias p='dev pnpm clean-publish --temp-dir .npm-release --without-publish && cd .npm-release && npm publish && cd .. && rm -R  .npm-release'

  # Google Cloud
  alias gcloud='sudo --user gcloud gcloud'

  # History
  HISTFILE=~/.histfile
fi
