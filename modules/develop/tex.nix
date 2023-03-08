{ config
, pkgs
, ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      texlive.combined.scheme-small
      texlab
    ];
  };
}
