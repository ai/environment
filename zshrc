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
zstyle :compinstall filename '/home/ai/.zshrc'
autoload -Uz compinit
compinit

# Zsh plugins
if [[ -d ~/.local/share/zsh/zsh-syntax-highlighting/ ]]; then
  source ~/.local/share/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
if [[ -d ~/.local/share/zsh/zsh-history-substring-search/ ]]; then
  source ~/.local/share/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
fi
if [[ -d ~/.local/share/zsh/zsh-autosuggestions/ ]]; then
  source ~/.local/share/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [[ -d ~/.local/share/zsh/pnpm-shell-completion/ ]]; then
  source ~/.local/share/zsh/pnpm-shell-completion/pnpm-shell-completion.plugin.zsh
fi

# Local binaries
export PATH="/home/$USER/.local/bin/:$PATH"

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
    elif [[ -f "$1/.devcontainer/devcontainer.json" ]]; then
      echo "$1/.devcontainer/devcontainer.json"
    else
      echo "$1/.devcontainer.json"
    fi
  }

  function dev () {
    local root=$(devcontainer_root)
    if [ "$root" = "" ]; then
      return 1
    fi
    local config=$(devcontainer_config $root)
    if [ "$PWD" = "$root" ]; then
      if [ -z "$1" ]; then
        devcontainer exec --docker-path podman \
          --workspace-folder $root --config $config \
          zsh
      else
        devcontainer exec --docker-path podman \
          --workspace-folder $root --config $config \
          zsh -ic "$*"
      fi
    else
      local reldir="${PWD#$root/}"
      if [ -z "$1" ]; then
        devcontainer exec --docker-path podman \
          --workspace-folder $root --config $config \
          zsh -c "cd $reldir; exec zsh"
      else
        devcontainer exec --docker-path podman \
          --workspace-folder $root --config $config \
          zsh -ic "cd $reldir && $*"
      fi
    fi
  }

  function devup () {
    local root=$(devcontainer_root)
    if [ "$root" = "" ]; then
      return 1
    fi
    devcontainer up --docker-path podman \
      --dotfiles-repository https://github.com/ai/environment.git \
      --dotfiles-install-command devcontainer/install-dotfiles \
      --workspace-folder $root --config $(devcontainer_config $root)
  }

  function devrebuild () {
    local root=$(devcontainer_root)
      if [ "$root" = "" ]; then
        return 1
      fi
      devdown
      podman image ls --format "{{.Repository}}:{{.Tag}}" | \
        grep "localhost/vsc-$(basename "$PWD")-" | \
        xargs -r podman image rm --force
      devup
  }

  alias devdown='podman kill --all'

  alias pnpm='dev pnpm'
  alias node='dev node'

  alias isolate="\
    cp ~/Dev/environment/devcontainer/devcontainer.json ./.devcontainer.json \
    && [ -d .git ] && echo '.devcontainer.json' >> .git/info/exclude || true"

  # Disable git hooks
  function chpwd() {
    if /usr/bin/git rev-parse --git-dir > /dev/null 2>&1; then
      if [[ -n "$(/usr/bin/git config --local --get core.hooksPath)" ]]; then
        echo -e "\e[33mGit hooks was disabled\e[0m"
      fi
    fi
  }
  chpwd
  export GIT_CONFIG_PARAMETERS="'core.hooksPath=/dev/null'"

  # Fast way to Dev projects
  if [ -d ~/Dev ]; then
    cdpath=(. ~/Dev)
  fi

  # VS Code
  export ELECTRON_TRASH=gio
  alias e='code .'

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
