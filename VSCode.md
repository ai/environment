# VS Code Extensions

Copy-paste following to terminal:

```bash
EXTENSIONS=(
  VisualStudioExptTeam.vscodeintellicode
  alefragnani.project-manager
  christian-kohler.npm-intellisense
  christian-kohler.path-intellisense
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
  ms-vscode-remote.remote-containers
  piousdeer.adwaita-theme
  pkief.material-icon-theme
  sleistner.vscode-fileutils
  streetsidesoftware.code-spell-checker
  visualstudioexptteam.vscodeintellicode
  walnuts1018.oklch-vscode
  yoavbls.pretty-ts-errors
  yzhang.markdown-all-in-one
)
for EXTENSION in ${EXTENSIONS[@]}; do
  code --install-extension $EXTENSION
done
```
