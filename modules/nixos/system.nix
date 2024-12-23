# Swap configuration
{ pkgs, ... }:
{
  config = {
    # LTS kernel
    boot.kernelPackages = pkgs.linuxPackages_6_12;

    # Swap
    zramSwap.enable = true;
  };
}
