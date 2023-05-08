{ pkgs
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
      # Enable this to render using the dedicated GPU
      # https://wiki.archlinux.org/title/PRIME#Wayland-specific_configuration
      DRI_PRIME = "pci-0000_01_00_0";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # __VK_LAYER_NV_optimus = "NVIDIA_only";
    };
  };
}
