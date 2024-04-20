# VS Code Extensions

Copy-paste following to terminal:

```bash
EXTENSIONS=(
  alefragnani.project-manager
  christian-kohler.npm-intellisense
  christian-kohler.path-intellisense
  compilouit.xkb
  connor4312.nodejs-testing
  csstools.postcss
  davidlday.languagetool-linter
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
  yzhang.markdown-all-in-one
)
for EXTENSION in ${EXTENSIONS[@]}; do
  code --install-extension $EXTENSION
done
```
