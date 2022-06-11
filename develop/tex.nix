{ config
, pkgs
, ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      (texlive.combine { inherit (pkgs.texlive) scheme-medium sectsty; })

      texlab
    ];
  };
}
