{ pkgs }:
with pkgs;
[
  nodejs
  nodePackages."@tailwindcss/language-server"
  nodePackages.prettier
  nodePackages.typescript
  nodePackages.typescript-language-server
]
