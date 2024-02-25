# Nix config
{ lib
, ...
}: {
  imports = [ ./cachix.nix ];
  config =
    {
      # Allow unfree packages: nvidia drivers, ...
      nixpkgs.config.allowUnfree = true;

      nix = {
        settings = {
          auto-optimise-store = true;
          # Enable flakes system wide, this will no loner be necessary in some future release
          experimental-features = [ "nix-command" "flakes" ];
          # nix options for derivations to persist garbage collection
          keep-outputs = true;
          keep-derivations = true;
          # Avoid copying unnecessary stuff over SSH
          builders-use-substitutes = true;
          # Avoid disk full issues
          max-free = lib.mkDefault (3000 * 1024 * 1024);
          min-free = lib.mkDefault (512 * 1024 * 1024);
          # The default at 10 is rarely enough.
          log-lines = lib.mkDefault 25;
        };

        extraOptions = ''
          !include access-tokens.conf
        '';
      };
    };
}
