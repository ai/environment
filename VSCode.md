# VS Code Extensions

Copy-paste following to terminal:

```bash
EXTENSIONS=(
 rafaelmardojai.vscode-gnome-theme
 fkrull.gtk-dark-titlebar
 christian-kohler.npm-intellisense
 coenraads.bracket-pair-colorizer
 dbaeumer.vscode-eslint
 editorconfig.editorconfig
 mhmadhamster.postcss-language
 mikestead.dotenv
 stylelint.vscode-stylelint
 visualstudioexptteam.vscodeintellicode
 william-voyek.vscode-nginx
 yzhang.markdown-all-in-one
 PKief.material-icon-theme
 christian-kohler.path-intellisense
 alefragnani.project-manager
 mhutchie.git-graph
 mariusschulz.yarn-lock-syntax
 bungcip.better-toml
 ms-azuretools.vscode-docker
 ms-python.python
 esbenp.prettier-vscode
 kshetline.ligatures-limited
 formulahendry.auto-rename-tag
)
for EXTENSION in ${EXTENSIONS[@]}; do
  code --install-extension $EXTENSION
done
```
