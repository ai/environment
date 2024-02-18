# VS Code Extensions

Copy-paste following to terminal:

```bash
EXTENSIONS=(
  alefragnani.project-manager
  christian-kohler.npm-intellisense
  christian-kohler.path-intellisense
  connor4312.nodejs-testing
  csstools.postcss
  dbaeumer.vscode-eslint
  editorconfig.editorconfig
  esbenp.prettier-vscode
  formulahendry.auto-rename-tag
  github.copilot
  github.copilot-chat
  kshetline.ligatures-limited
  mikestead.dotenv
  mrorz.language-gettext
  piousdeer.adwaita-theme
  pkief.material-icon-theme
  streetsidesoftware.code-spell-checker
  streetsidesoftware.code-spell-checker-russian
  stylelint.vscode-stylelint
  svelte.svelte-vscode
  tamasfe.even-better-toml
  visualstudioexptteam.vscodeintellicode
  webben.browserslist
  yoavbls.pretty-ts-errors
)
for EXTENSION in ${EXTENSIONS[@]}; do
  code --install-extension $EXTENSION
done
```
