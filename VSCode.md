# VS Code Extensions

Copy-paste following to terminal:

```bash
EXTENSIONS=(
  alefragnani.project-manager
  christian-kohler.npm-intellisense
  christian-kohler.path-intellisense
  dbaeumer.vscode-eslint
  EditorConfig.EditorConfig
  esbenp.prettier-vscode
  fkrull.gtk-dark-titlebar
  formulahendry.auto-rename-tag
  kshetline.ligatures-limited
  mariusschulz.yarn-lock-syntax
  mhmadhamster.postcss-language
  mikestead.dotenv
  mrorz.language-gettext
  ms-azuretools.vscode-docker
  MS-CEINTL.vscode-language-pack-ru
  PKief.material-icon-theme
  rafaelmardojai.vscode-gnome-theme
  ryanluker.vscode-coverage-gutters
  sianglim.slim
  streetsidesoftware.code-spell-checker
  streetsidesoftware.code-spell-checker-russian
  stylelint.vscode-stylelint
  svelte.svelte-vscode
  VisualStudioExptTeam.vscodeintellicode
  webben.browserslist
  yzhang.markdown-all-in-one
)
for EXTENSION in ${EXTENSIONS[@]}; do
  code --install-extension $EXTENSION
done
```
