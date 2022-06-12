{ config
, pkgs
, lib
, ...
}: {
  config = {
    services.xserver.videoDrivers = [
      "nvidia"
      "amdgpu"
      "radeon"
      "modesetting"
      "fbdev"
    ];

    hardware.opengl = {
      enable = true;

      extraPackages = with pkgs; [
        rocm-opencl-icd
        rocm-opencl-runtime
        amdvlk
        vaapiVdpau
      ];

      extraPackages32 = with pkgs; [
        driversi686Linux.amdvlk
      ];

      driSupport = true;
      driSupport32Bit = true;
    };


    hardware.nvidia = {
      powerManagement = {
        enable = true;
        finegrained = true;
      };

      nvidiaPersistenced = true;

      modesetting.enable = true;
      prime = {
        offload.enable = true;

        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };

    services.xserver.deviceSection = ''
      Option "AllowExternalGpus"
    '';

    services.xserver.serverLayoutSection = ''
      Inactive "Device-nvidia[0]"
      Option "AllowNVIDIAGPUScreens"
    '';

    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0
    '';

    services.xserver.displayManager.gdm.wayland = false;
  };
}
