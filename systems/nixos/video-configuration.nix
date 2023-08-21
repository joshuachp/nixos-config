{ pkgs
, ...
}: {
  config = {
    services.xserver.exportConfiguration = true;

    services.xserver.videoDrivers = [
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

        vulkan-validation-layers
        vulkan-extension-layer
      ];

      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];
    };

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

    # Enable this to render using the dedicated GPU
    # https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/1562
    # services.udev.extraRules = ''
    #   ENV{DEVNAME}=="/dev/dri/card1", TAG+="mutter-device-preferred-primary"
    # '';

    # Render on the Nvidia GPU by default
    # NOTE: this is more for a single application
    # environment.variables = {
    #    Enable this to render using the dedicated GPU
    #    https://wiki.archlinux.org/title/PRIME#Wayland-specific_configuration
    #    DRI_PRIME = "1";
    #    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    #    __VK_LAYER_NV_optimus = "NVIDIA_only";
    # };
  };
}
