# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config
, lib
, pkgs
, modulesPath
, ...
}: {
  imports = [ ];
  config = {
    boot = {
      initrd = {
        availableKernelModules = [ ];
        kernelModules = [ ];
      };
      kernelModules = [ ];
      extraModulePackages = [ ];
    };

    fileSystems."/" = {
      device = "/dev/sdb";
      fsType = "ext4";
    };

    swapDevices = [ ];

    hardware = {
      enableRedistributableFirmware = true;
      cpu.amd.updateMicrocode = true;
    };
  };
}
