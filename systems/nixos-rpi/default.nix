{ config
, pkgs
, lib
, nixos-hardware
, modulesPath
, ...
}: {
  imports = [
    # Module to build the sd-card image
    (modulesPath + "/installer/sd-card/sd-image-aarch64.nix")
  ];
  config = {
    # RPI specific settings
    hardware.enableRedistributableFirmware = true;

    # from the RPi4 conf
    boot = {
      kernelPackages = pkgs.linuxPackages_rpi3;
      initrd.availableKernelModules = [
        "usbhid"
        "usb_storage"
        "vc4"
        "pcie_brcmstb" # required for the pcie bus to work
        "reset-raspberrypi" # required for vl805 firmware to load
      ];
      initrd.kernelModules = [ ];
      kernelModules = [ ];
      # # ttyAMA0 is the serial console broken out to the GPIO
      # kernelParams = [
      #   "8250.nr_uarts=1"
      #   "console=ttyAMA0,115200"
      #   "console=tty1"
      #   # A lot GUI programs need this, nearly all wayland applications
      #   "cma=128M"
      # ];
    };

    # boot.loader.raspberryPi = {
    #   enable = true;
    #   version = 3;
    # };
    boot.loader = {
      grub.enable = lib.mkDefault false;
      generic-extlinux-compatible.enable = lib.mkDefault true;
    };

    networking.wireless.enable = true;
    # networking.networkmanager.enable = true;

    nix = {
      settings.auto-optimise-store = true;
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
      # Free up to 1GiB whenever there is less than 100MiB left.
      extraOptions = ''
        min-free = ${toString (100 * 1024 * 1024)}
        max-free = ${toString (1024 * 1024 * 1024)}
      '';
    };
  };
}
