# VS Code Extensions

Copy-paste following to terminal:

```bash
EXTENSIONS=(
  alefragnani.project-manager
  christian-kohler.npm-intellisense
  christian-kohler.path-intellisense
  csstools.postcss
  dbaeumer.vscode-eslint
  EditorConfig.EditorConfig
  esbenp.prettier-vscode
  formulahendry.auto-rename-tag
  GitHub.copilot
  kshetline.ligatures-limited
  mikestead.dotenv
  mrorz.language-gettext
  ms-azuretools.vscode-docker
  ms-vscode.live-server
  PKief.material-icon-theme
  rafaelmardojai.vscode-gnome-theme
  sianglim.slim
  streetsidesoftware.code-spell-checker
  streetsidesoftware.code-spell-checker-russian
  stylelint.vscode-stylelint
  svelte.svelte-vscode
  tamasfe.even-better-toml
  VisualStudioExptTeam.intellicode-api-usage-examples
  VisualStudioExptTeam.vscodeintellicode
  webben.browserslist
  yoavbls.pretty-ts-errors
)
for EXTENSION in ${EXTENSIONS[@]}; do
  code --install-extension $EXTENSION
done
```
