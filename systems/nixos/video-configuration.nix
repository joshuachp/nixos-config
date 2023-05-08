{ config
, pkgs
, lib
, ...
}: {
  config = {
    services.xserver.exportConfiguration = true;

    services.xserver.videoDrivers = [
      "amdgpu"
      "nvidia"
    ];

    hardware.opengl = {
      enable = true;

      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
        vaapiVdpau
      ];

      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };

    hardware.nvidia = {
      nvidiaPersistenced = true;

      modesetting.enable = true;

      prime = {
        sync.enable = true;

        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    # Render on the Nvidia GPU by default
    environment.variables = {
      DRI_PRIME = "1";
    };
  };
}
