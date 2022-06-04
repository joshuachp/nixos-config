{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    stylua
    sumneko-lua-language-server
  ];
}
