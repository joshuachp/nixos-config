# Nix config
{ lib, ... }:
{
  imports = [ ./cachix.nix ];
  config = {
    # Allow unfree packages: nvidia drivers, ...
    nixpkgs.config.allowUnfree = true;

    nix = {
      settings = {
        # Enable flakes system wide, this will no loner be necessary in some future release
        experimental-features = [
          "nix-command"
          "flakes"
          # container like builds
          "auto-allocate-uids"
          "cgroups"
        ];
        # Hard link same files
        auto-optimise-store = lib.mkDefault true;
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
        # Container like builds
        auto-allocate-uids = true;
        system-features = [ "uid-range" ];
      };

      extraOptions = ''
        !include access-tokens.conf
      '';
    };
  };
}
