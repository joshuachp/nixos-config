{ pkgs
, ...
}: {
  environment.systemPackages = with pkgs; [
    pavucontrol
    easyeffects
  ];
}
