{ pkgs, ... }: {
  imports = [ ./cachix.nix ];

  environment.systemPackages = with pkgs; [
    cachix
  ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
  };
}
