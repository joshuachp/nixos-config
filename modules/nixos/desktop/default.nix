{
  self,
  config,
  pkgs,
  lib,
  flakeInputs,
  ...
}:
{
  imports = [
    ./audio.nix
    ./browser.nix
    ./cli.nix
    ./develop
    ./documentation.nix
    ./fonts.nix
    ./games.nix
    ./keyboard.nix
    ./plymouth.nix
    ./qt.nix
    ./security.nix
    ./services.nix
    ./virtualisation.nix
    ./wayland.nix
    ./wm
  ];
  config = {
    assertions = [
      {
        assertion = !config.systemConfig.minimal;
        message = "Desktop cannot be minimal";
      }
    ];
    # Desktop service
    services = {
      xserver = {
        enable = true;
        xkb.layout = "us";
        # Desktop environment
        displayManager.gdm.enable = true;
      };

      # Enable touchpad support (enabled default in most desktopManager).
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
        };
      };

      # Firmware updates
      fwupd.enable = true;
    };

    environment.systemPackages = import "${self}/pkgs/desktop.nix" { inherit pkgs lib config; };

    home-manager = {
      sharedModules = [
        flakeInputs.neovimConfig.homeManagerModules.default
        ../../homeManager/desktop
      ];
    };

    networking.firewall = {
      allowedTCPPorts = [
        # Syncthing local firewall
        # https://docs.syncthing.net/users/firewall.html#local-firewall
        22000
      ];
      allowedUDPPorts = [
        # Syncthing local firewall
        22000
        21027
        # mdns
        5353
      ];
    };
  };
}
