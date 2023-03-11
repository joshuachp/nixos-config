{ pkgs }: with pkgs; [
  nodejs
  nodePackages."@tailwindcss/language-server"
  nodePackages.prettier
  nodePackages.svelte-language-server
  nodePackages.typescript
  nodePackages.typescript-language-server
  nodePackages.vscode-langservers-extracted
]
