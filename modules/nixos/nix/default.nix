# Nix configuration
{
  self,
  pkgs,
  flakeInputs,
  lib,
  config,
  ...
}:
let
  desktop = config.systemConfig.desktop.enable;
  cfg = config.nixosConfig.nix;
  inherit (flakeInputs) nixpkgs;
in
{
  options = {
    # Enable nix-index and command not found
    nixosConfig.nix = {
      index.enable = lib.mkEnableOption "nix-index" // {
        default = desktop;
      };
      update-diff.enable = lib.mkEnableOption "show package diff when updating nixos" // {
        default = desktop;
      };
    };
  };
  config = lib.mkMerge [
    {
      nix = {
        gc = {
          automatic = true;
          dates = "Mon *-*-* 12:45";
        };
        # Periodically optimise the store
        optimise = {
          automatic = true;
          dates = [ "Mon *-*-* 12:45" ];
        };
        # Nix flake registry
        registry.nixpkgs.flake = nixpkgs;
        # Disable nix channels, but keep the system compatible
        channel.enable = false;
        settings.nix-path = "nixpkgs=${nixpkgs}";
      };
      environment = {
        systemPackages = import "${self}/pkgs/nixpkgs.nix" pkgs;
        pathsToLink = [ "/share/nix-direnv" ];
      };
      # Nix index
      programs = {
        nix-index.enable = cfg.index.enable;
        command-not-found.enable = lib.mkIf cfg.index.enable (lib.mkDefault false);
      };

      # https://github.com/nix-community/srvos/blob/8d159ac5bb67368509861cf1a94717402d8d216e/nixos/common/nix.nix#L20
      nix.daemonCPUSchedPolicy = lib.mkDefault (
        # improve desktop responsiveness when updating the system
        if desktop then "idle" else "batch"
      );
      nix.daemonIOSchedClass = lib.mkDefault "idle";
      nix.daemonIOSchedPriority = lib.mkDefault 7;

    }
    # Show update diff
    (lib.mkIf cfg.update-diff.enable {
      system.activationScripts.update-diff = {
        supportsDryActivation = true;
        text =
          let
            nix = config.nix.package;
          in
          ''
            if [[ -e /run/current-system ]]; then
              echo "Packages updated:"
              ${nix}/bin/nix store diff-closures /run/current-system "$systemConfig"
            fi
          '';
      };
    })
  ];
}
