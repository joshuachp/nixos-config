# Documentation configuration
{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.nixosConfig.documentation;
in
{
  options = {
    nixosConfig.documentation.enable = lib.mkEnableOption "documentation" // {
      default = config.systemConfig.desktop.enable;
    };
  };
  config = lib.mkIf cfg.enable {
    # Enable info and man pages, generating the cache at build time
    documentation = {
      enable = true;
      dev.enable = true;
      info.enable = true;
      nixos.enable = true;
      man = {
        enable = true;
        generateCaches = true;
      };
    };

    environment.systemPackages = with pkgs;[
      man-pages
      # POSIX man-pages for system calls and libraries
      man-pages-posix
    ];
  };
}
