{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    luaformatter
    sumneko-lua-language-server
  ];
}
