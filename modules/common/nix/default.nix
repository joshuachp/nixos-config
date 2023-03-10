{ config
, pkgs
, lib
, ...
}: {
  imports = [ ./cachix.nix ];
  config =
    {
      # Allow unfree packages: nvidia drivers, ...
      nixpkgs.config.allowUnfree = true;

      # Enable flakes system wide, this will no loner be necessary in some future release
      nix.settings.experimental-features = [ "nix-command" "flakes" ];

      nix.settings.auto-optimise-store = true;

      nix.extraOptions = ''
        !include access-tokens.conf
      '';

      # nix options for derivations to persist garbage collection
      nix.settings = {
        keep-outputs = true;
        keep-derivations = true;
      };

      # Support flakes in nix direnv
      nixpkgs.overlays = [
        (self: super: { nix-direnv = super.nix-direnv.override { enableFlakes = true; }; })
      ];
    };
}
