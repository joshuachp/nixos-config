{ lib
, ...
}: {
  config = {
    # clean /tmp on boot
    boot.tmp.cleanOnBoot = lib.mkDefault true;
  };
}
