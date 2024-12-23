{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    nixosConfig.desktop.games.enable = lib.mkEnableOption "enable gaming configuration";
  };
  config =
    let
      cfg = config.nixosConfig.desktop.games;
    in
    lib.mkIf cfg.enable {
      specialisation = {
        gaming.configuration = {
          system.nixos.tags = [ "gaming" ];

          programs = {
            steam = {
              enable = true;
              gamescopeSession.enable = true;
              extest.enable = true;
              extraPackages = with pkgs; [
                gamescope
                gamemode
              ];
              extraCompatPackages = with pkgs; [
                proton-ge-bin
              ];
            };
            gamescope = {
              enable = true;
              capSysNice = true;
            };
            gamemode = {
              enable = true;
              settings = {
                general = {
                  renice = 10;
                  softrealtime = "on";
                };
                custom = {
                  start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
                  end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
                };
              };
            };
          };
          users.users.joshuachp.extraGroups = [ "gamemode" ];

          boot = {
            kernelParams = [
              # Low latency kernel parameters
              "preempt=full"
              "threadirqs"
              "mitigations=off"
            ];
            kernel.sysctl = {
              "vm.max_map_count" = 2147483642;
            };
          };
        };
      };
    };
}
