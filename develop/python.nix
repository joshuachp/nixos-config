{ config
, pkgs
, ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      python3Full
      nodePackages.pyright
    ];
  };
}
