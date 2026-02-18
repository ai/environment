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
bindkey ';5D' backward-word # Ctrl+Left
bindkey ';5C' forward-word  # Ctrl+Right
stty intr ^X                # Replace Ctrl+C to Ctrl+X
stty susp undef             # Disable Ctrl + Z

# Force keeping home folder clean
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export NODE_COMPILE_CACHE="$XDG_CACHE_HOME/node"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npmrc"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgreprc"
export CLAUDE_CONFIG_DIR="$XDG_DATA_HOME/claude"

# Completion
zstyle :compinstall filename "$HOME/.zshrc"
autoload -Uz compinit
compinit -i -d "$XDG_CACHE_HOME/zcompcache"

# Zsh plugins
export HISTORY_BASE="$XDG_CACHE_HOME/zsh_directory_history"
for plugin in \
  zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  zsh-autosuggestions/zsh-autosuggestions.zsh \
  per-directory-history/per-directory-history.zsh \
  pnpm-shell-completion/pnpm-shell-completion.plugin.zsh
do
  for dir in ~/.local/lib/zsh /usr/local/lib/zsh; do
    if [[ -f $dir/$plugin ]]; then
      source $dir/$plugin
      break
    fi
  done
done

# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# Prompt
if command -v starship > /dev/null 2>&1; then
  eval "$(starship init zsh)"
elif [ -f ~/.local/bin/starship ]; then
  eval "$(~/.local/bin/starship init zsh)"
fi

# History
if [ -f ~/.local/bin/atuin ]; then
  eval "$(~/.local/bin/atuin init zsh --disable-up-arrow)"
fi

# Rip Grep

# Console editor
export EDITOR=micro

# Fix Bat in light console
export BAT_THEME=ansi

# Release function
release() {
  local VERSION=$(grep -oP '(?<="version": ")[^"]*' package.json)

  if [ -z "$VERSION" ]; then
    echo "Version not found in package.json"
    return 1
  fi

  git add .
  git commit -m "Release $VERSION version"
  git tag -s "$VERSION" -m "$VERSION"
  git push
}

# Aliases
alias g='git'
alias ..='cd ..'
alias l='ls --all'
alias ll='ls --long --all --git'

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

if [ -n "$container" ]; then
  alias dev='command'

  if [ -z "$SSH_AUTH_SOCK" ] && [ -S "/run/user/1000/gcr/ssh" ]; then
    export SSH_AUTH_SOCK="/run/user/1000/gcr/ssh"
  fi
else
  # Run commands in container
  export PATH="/home/ai/.local/lib/node/node_modules/.bin/:$PATH"

  alias dev='/home/ai/Dev/environment/bin/dev'
  alias devup='dev --up'
  alias devdown='dev --down'
  alias pnpm='dev pnpm'
  alias node='dev node'
  alias multiocular='dev --port pnpm multiocular'

  # Run git hooks inside Dev Container
  export GIT_CONFIG_PARAMETERS="'core.hooksPath=/home/ai/Dev/environment/hooks-trap'"

  # Fast way to Dev projects
  if [ -d ~/Dev ]; then
    cdpath=(. ~/Dev)
  fi

  # Zed
  alias e='~/Dev/environment/bin/zed-isolate .'

  # Development
  alias p='dev pnpm clean-publish --temp-dir .npm-release --without-publish \
    && cd .npm-release \
    && npm publish --access public \
    && cd .. \
    && rm -R  .npm-release'
fi
