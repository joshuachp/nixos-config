{ config
, ...
}: {
  config = {
    services.xserver.windowManager.i3.enable = true;

    services.xserver.windowManager.awesome = {
      enable = true;
      # luaModules = with pkgs.luaPackages; [];
    };
  };
}
