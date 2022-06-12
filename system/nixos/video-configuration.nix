{ config
, pkgs
, lib
, ...
}: {
  config = {
    services.xserver.displayManager.gdm.debug = true;
    services.xserver.verbose = lib.mkForce 7;
    services.xserver.exportConfiguration = true;

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

      driSupport = true;
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

    environment.etc."X11/xorg.conf.d/10-amdgpu.conf".text = ''
      Section "OutputClass"
          Identifier "AMDgpu"
          MatchDriver "amdgpu"
          Driver "amdgpu"
      EndSection
    '';

    environment.etc."X11/xorg.conf.d/10-radeon.conf".text = ''
      Section "OutputClass"
          Identifier "Radeon"
          MatchDriver "radeon"
          Driver "radeon"
      EndSection
    '';

    environment.etc."X11/xorg.conf.d/10-nvidia.conf".text = ''
      Section "OutputClass"
          Identifier "nvidia"
          MatchDriver "nvidia-drm"
          Driver "nvidia"
          Option "AllowEmptyInitialConfiguration"
          Option "SLI" "Auto"
          Option "BaseMosaic" "on"
      EndSection

      Section "ServerLayout"
          Identifier "layout"
          Option "AllowNVIDIAGPUScreens"
      EndSection
    '';

    services.xserver.config = lib.mkForce "";

    services.xserver.displayManager.gdm.wayland = false;

  };
}
