# VS Code Extensions

Copy-paste following to terminal:

```bash
EXTENSIONS=(
  alefragnani.project-manager
  bungcip.better-toml
  christian-kohler.npm-intellisense
  christian-kohler.path-intellisense
  CoenraadS.bracket-pair-colorizer
  csstools.postcss
  dbaeumer.vscode-eslint
  EditorConfig.EditorConfig
  esbenp.prettier-vscode
  fkrull.gtk-dark-titlebar
  formulahendry.auto-rename-tag
  kshetline.ligatures-limited
  mariusschulz.yarn-lock-syntax
  mhmadhamster.postcss-language
  mhutchie.git-graph
  mikestead.dotenv
  ms-azuretools.vscode-docker
  PKief.material-icon-theme
  rafaelmardojai.vscode-gnome-theme
  stylelint.vscode-stylelint
  VisualStudioExptTeam.vscodeintellicode
  webben.browserslist
  william-voyek.vscode-nginx
  yzhang.markdown-all-in-one
)
for EXTENSION in ${EXTENSIONS[@]}; do
  code --install-extension $EXTENSION
done
```
