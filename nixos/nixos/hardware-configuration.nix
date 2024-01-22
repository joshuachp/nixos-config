# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ lib
, pkgs
, modulesPath
, system
, ...
}: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
  config = {
    # Use the systemd-boot EFI boot loader.
    boot = {
      loader = {
        systemd-boot.enable = true;
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/efi";
        };
      };
      kernelPackages = pkgs.linuxPackages_6_6;
      initrd = {
        availableKernelModules = [ "xhci_pci" "nvme" "ahci" "usbhid" "sd_mod" "usb_storage" ];
        kernelModules = [ "dm-snapshot" "amdgpu" ];
        luks.devices.crypted = {
          device = "/dev/disk/by-uuid/1fedcdd5-c220-4017-a773-a902b9f3fdcd";
        };
      };
      kernelModules = [ "kvm-amd" ];
      extraModulePackages = [ ];
      # extraModprobeConfig = ''
      #   options snd-hda-intel model=alc285-hp-amp-init
      # '';
    };

    fileSystems = {
      "/" = {
        device = "/dev/Linux/root";
        fsType = "btrfs";
        options = [ "subvol=root" ];
      };

      "/nix" = {
        device = "/dev/Linux/root";
        fsType = "btrfs";
        options = [ "subvol=nix" "noatime" ];
      };

      "/efi" = {
        device = "/dev/disk/by-uuid/A582-67FE";
        fsType = "vfat";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/a6dce445-4eb0-469e-898a-f2366e5d6605";
        fsType = "ext4";
      };

      "/home" = {
        device = "/dev/Linux/root";
        fsType = "btrfs";
        options = [ "subvol=home" ];
      };

      "/home/joshuachp/share" = {
        device = "/dev/Linux/share";
        fsType = "btrfs";
        options = [ "user" "exec" ];
      };

      "/var" = {
        device = "/dev/Linux/root";
        fsType = "btrfs";
        options = [ "subvol=var" ];
      };
    };

    swapDevices = [{ device = "/dev/Linux/swap"; }];

    nixpkgs.hostPlatform = lib.mkDefault system;
    hardware = {
      enableRedistributableFirmware = true;
      cpu.amd.updateMicrocode = true;
    };
  };
}
