# NixOS video configuration
{ lib
, ...
}: {
  config = {
    services.xserver.exportConfiguration = true;

    services.xserver.videoDrivers = [
      "nvidia"
    ];

    hardware.nvidia = {
      # Used for compute environments
      nvidiaPersistenced = false;
      modesetting.enable = true;
      forceFullCompositionPipeline = true;
      prime = {
        sync.enable = true;
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
