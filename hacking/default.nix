{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    cutter
    ghidra-bin

    radare2
  ];
}
