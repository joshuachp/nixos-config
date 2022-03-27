{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    nodePackages.bash-language-server
    shfmt
    shellcheck
  ];
}
