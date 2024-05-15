#!/bin/bash

cp gitconfig /home/ai/.gitconfig
cp ripgreprc /home/ai/.ripgreprc
cp micro.json /home/ai/.config/micro/settings.json
cp batconfig /home/ai/.config/bat/config
cp starship.toml /home/ai/.config/starship.toml
cp zshrc /home/ai/.zshrc
cp gitignore /home/ai/.config/git/ignore

if command -v micro >/dev/null 2>&1; then
  micro -plugin install editorconfig
fi

if command -v git >/dev/null 2>&1 && command -v zsh >/dev/null 2>&1; then
  git clone -q https://github.com/zsh-users/zsh-syntax-highlighting \
    ~/.zsh/zsh-syntax-highlighting
  git clone -q https://github.com/zsh-users/zsh-history-substring-search \
    ~/.zsh/zsh-history-substring-search
fi
