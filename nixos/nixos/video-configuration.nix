# NixOS video configuration
{ config, lib, ... }:
{
  config = {
    services.xserver.exportConfiguration = true;

    services.xserver.videoDrivers = [ "nvidia" ];

    environment.variables = {
      DRI_PRIME = "pci-0000_01_00_0";
      __VK_LAYER_NV_optimus = "NVIDIA_only";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    hardware.nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.production;

      # Used for compute environments
      modesetting.enable = true;

      # Borked or unsupported
      forceFullCompositionPipeline = false;
      nvidiaPersistenced = false;
      dynamicBoost.enable = false;

      prime = {
        sync.enable = false;

        # offload.enableOffloadCmd = true;

        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    specialisation = {
      singleMonitor.configuration = {
        system.nixos.tags = [ "singleMonitor" ];

        hardware.nvidia = {
          prime = {
            offload = {
              enable = lib.mkForce true;
              enableOffloadCmd = lib.mkForce true;
            };
            sync.enable = lib.mkForce false;
          };
        };
      };
    };
  };
}
