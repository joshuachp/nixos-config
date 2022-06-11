{ config
, pkgs
, ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      nodePackages.bash-language-server
      shfmt
      shellcheck
    ];
  };
}
