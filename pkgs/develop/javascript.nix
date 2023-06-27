{ pkgs }: with pkgs; [
  nodejs
  nodePackages."@tailwindcss/language-server"
  nodePackages.prettier
  nodePackages.typescript
  nodePackages.typescript-language-server
  # TODO: was broken, re-add when fixed
  # nodePackages.vscode-langservers-extracted
]
