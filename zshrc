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

# Node.js
alias n='npx --no-install'
alias yui='yarn upgrade-interactive --latest'
alias yu='yarn upgrade'
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

# Python
export PATH=~/.local/bin/:$PATH

# Fix mpv
export MESA_LOADER_DRIVER_OVERRIDE=i965
