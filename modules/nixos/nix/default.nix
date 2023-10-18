# Nix configuration
{ pkgs
, flakeInputs
, lib
, config
, ...
}: {
  imports = [
    ../../common/nix
  ];
  options = {
    # Enable nix-index and command not found
    nixosConfig.nix.index.enable = lib.options.mkEnableOption "nix-index";
  };
  config =
    let
      cfg = config.nixosConfig.nix;
      inherit (flakeInputs) nixpkgs;
    in
    lib.mkMerge [
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
      }
      (lib.mkIf cfg.index.enable {
        # Nix index for command-not-found
        programs = {
          nix-index.enable = true;
          command-not-found.enable = false;
        };
      })
    ];
}
