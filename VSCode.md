# VS Code Extensions

Copy-paste following to terminal:

```bash
EXTENSIONS=(
  alefragnani.project-manager
  christian-kohler.npm-intellisense
  christian-kohler.path-intellisense
  csstools.postcss
  davidlday.languagetool-linter
  editorconfig.editorconfig
  formulahendry.auto-rename-tag
  github.copilot
  github.copilot-chat
  kshetline.ligatures-limited
  ms-vscode-remote.remote-containers
  piousdeer.adwaita-theme
  pkief.material-icon-theme
  streetsidesoftware.code-spell-checker
  streetsidesoftware.code-spell-checker-russian
  visualstudioexptteam.vscodeintellicode
  yoavbls.pretty-ts-errors
  yzhang.markdown-all-in-one
)
for EXTENSION in ${EXTENSIONS[@]}; do
  code --install-extension $EXTENSION
done
```
