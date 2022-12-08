{ config
, pkgs
, ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      cutter

      radare2
    ];
  };
}
