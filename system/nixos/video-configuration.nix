{ config
, pkgs
, lib
, ...
}: {
  config = {
    services.xserver.exportConfiguration = true;

    services.xserver.videoDrivers = [
      # "modesetting"
      # "fbdev"
      "amdgpu"
      "nvidia"
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
      #powerManagement = {
      #  enable = true;
      #  finegrained = true;
      #};

      nvidiaPersistenced = true;

      modesetting.enable = true;

      prime = {
        #offload.enable = true;
        sync.enable = true;

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

    services.xserver.config = lib.mkForce ''
      Section "ServerFlags"
        Option "AllowMouseOpenFail" "on"
        Option "DontZap" "on"
      EndSection

      Section "Module"
      EndSection

      Section "Monitor"
        Identifier "Monitor[0]"
      EndSection

      # Additional "InputClass" sections
      Section "InputClass"
        Identifier "libinput mouse configuration"
        MatchDriver "libinput"
        MatchIsPointer "on"
        Option "AccelProfile" "adaptive"
        Option "LeftHanded" "off"
        Option "MiddleEmulation" "on"
        Option "NaturalScrolling" "off"
        Option "ScrollMethod" "twofinger"
        Option "HorizontalScrolling" "on"
        Option "SendEventsMode" "enabled"
        Option "Tapping" "on"
        Option "TappingDragLock" "on"
        Option "DisableWhileTyping" "off"
      EndSection

      Section "InputClass"
        Identifier "libinput touchpad configuration"
        MatchDriver "libinput"
        MatchIsTouchpad "on"
        Option "AccelProfile" "adaptive"
        Option "LeftHanded" "off"
        Option "MiddleEmulation" "on"
        Option "NaturalScrolling" "off"
        Option "ScrollMethod" "twofinger"
        Option "HorizontalScrolling" "on"
        Option "SendEventsMode" "enabled"
        Option "Tapping" "on"
        Option "TappingDragLock" "on"
        Option "DisableWhileTyping" "off"
      EndSection

      Section "ServerLayout"
        Identifier "Layout[all]"
        Inactive "Device-amdgpu[0]"

        # Reference the Screen sections for each driver.  This will
        # cause the X server to try each in turn.
        Screen "Screen-nvidia[0]"
        Screen "Screen-amdgpu[0]"
      EndSection

      # For each supported driver, add a "Device" and "Screen"
      # section.
      Section "Device"
        Identifier "Device-nvidia[0]"
        Driver "nvidia"
        BusID "PCI:1:0:0"
      EndSection

      Section "Screen"
        Identifier "Screen-nvidia[0]"
        Device "Device-nvidia[0]"
        Option "RandRRotation" "on"
        Option "AllowEmptyInitialConfiguration"
      EndSection

      Section "Screen"
        Identifier "Screen-amdgpu[0]"
        Device "Device-amdgpu[0]"
      EndSection


      Section "Device"
        Identifier "Device-amdgpu[0]"
        Driver "amdgpu"
        BusID "PCI:5:0:0"
      EndSection
    '';

    services.xserver.displayManager.gdm.wayland = false;

  };
}
