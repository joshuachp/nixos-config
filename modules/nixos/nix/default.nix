# Nix configuration
{ pkgs
, flakeInputs
, lib
, config
, ...
}: {
  imports = [
    # Pre-generated nix index database
    flakeInputs.nix-index-database.nixosModules.nix-index
  ];
  options = {
    # Enable nix-index and command not found
    nixosConfig.nix.index.enable = lib.options.mkEnableOption "nix-index";
  };
  config =
    let
      desktop = config.systemConfig.desktop.enable;
      cfg = config.nixosConfig.nix;
      inherit (flakeInputs) nixpkgs;
    in
    {
      nix = {
        gc = {
          automatic = true;
          dates = "weekly";
        };
        # Periodically optimise the store
        optimise = {
          automatic = true;
          dates = [ "weekly" ];
        };
        # Nix flake registry
        registry.nixpkgs.flake = nixpkgs;
        # Disable nix channels, but keep the system compatible
        channel.enable = false;
        settings.nix-path = "nixpkgs=${nixpkgs}";
      };
      environment = {
        systemPackages = import ../../../pkgs/nixpkgs.nix pkgs;
        pathsToLink = [
          "/share/nix-direnv"
        ];
      };

      # Nix index
      programs = {
        nix-index.enable = cfg.index.enable;
        command-not-found.enable = lib.mkIf cfg.index.enable (lib.mkDefault false);
      };
    };
}
