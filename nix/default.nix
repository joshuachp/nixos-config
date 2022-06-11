{ config
, pkgs
, ...
}: {
  imports = [ ./cachix.nix ];
  config = {
    environment.systemPackages = with pkgs; [
      cachix
    ];

    nix.gc = {
      automatic = true;
      dates = "weekly";
    };
  };
}
