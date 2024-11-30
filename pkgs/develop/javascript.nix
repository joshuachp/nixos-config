{ pkgs }:
with pkgs;
[
  nodejs
  nodePackages."@tailwindcss/language-server"
  nodePackages.prettier
  typescript
  vscode-langservers-extracted
  typescript-language-server
]
