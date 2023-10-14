_: {
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
        };

        extraOptions = ''
          !include access-tokens.conf
        '';
      };
    };
}
