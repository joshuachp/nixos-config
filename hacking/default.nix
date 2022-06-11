{ config
, pkgs
, ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      cutter
      ghidra-bin

      radare2
    ];
  };
}
