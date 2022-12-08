{ config
, pkgs
, ...
}: {
  imports = [ ./cachix.nix ];
  config = {
    # Allow unfree packages: nvidia drivers, ...
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      cachix
    ];

    # Enable flakes system wide, this will no loner be necessary in some future release
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    nix.settings.auto-optimise-store = true;

    nix.optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
    };
  };
}
