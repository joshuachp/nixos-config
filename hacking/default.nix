{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    radare2
    cutter
  ];
}
