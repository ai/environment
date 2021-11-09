# VS Code Extensions

Copy-paste following to terminal:

```bash
EXTENSIONS=(
  alefragnani.project-manager
  bungcip.better-toml
  christian-kohler.npm-intellisense
  christian-kohler.path-intellisense
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
  monasticpanic.vscode-astroturf
  mrorz.language-gettext
  ms-azuretools.vscode-docker
  MS-CEINTL.vscode-language-pack-ru
  PKief.material-icon-theme
  rafaelmardojai.vscode-gnome-theme
  streetsidesoftware.code-spell-checker
  streetsidesoftware.code-spell-checker-russian
  stylelint.vscode-stylelint
  svelte.svelte-vscode
  VisualStudioExptTeam.vscodeintellicode
  webben.browserslist
  william-voyek.vscode-nginx
  yzhang.markdown-all-in-one
)
for EXTENSION in ${EXTENSIONS[@]}; do
  code --install-extension $EXTENSION
done
```
