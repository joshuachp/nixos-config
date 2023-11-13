# NixOS video configuration
_: {
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
  };
}
