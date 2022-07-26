{ config
, pkgs
, ...
}: {
  imports = [ ./cachix.nix ];
  config = {
    environment.systemPackages = with pkgs; [
      cachix
    ];

    nix.settings.auto-optimise-store = true;

    nix.optimise = {
      automatic = true;
      dates = "weekly";
    };

    nix.gc = {
      automatic = true;
      dates = "weekly";
    };
  };
}
