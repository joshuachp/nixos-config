{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nodePackages."@tailwindcss/language-server"
    nodePackages.prettier
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
  ];
}
