{ config, pkgs, lib, ... }: {
  services.xserver.videoDrivers = lib.mkAfter [ "nvidia" ];

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

  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0
  '';

  services.xserver.displayManager.gdm.wayland = false;

  services.xserver.config = lib.mkForce ''
    Section "ServerLayout"
        Identifier      "Server Layout"
        Screen          0 "Main Screen"
    EndSection

    Section "Screen"
        Identifier      "Main Screen"
        Device          "AMD Card"
        GPUDevice       "Nvidia Card"
        #Device          "Nvidia Card"
        #GPUDevice       "AMD Card"
        Monitor         "eDP"
        Option          "AllowEmptyInitialConfiguration"
    EndSection

    Section "Monitor"
        Identifier      "eDP"
        Option          "Primary" "true"
        Option          "Enable" "true"
        Option          "DPMS" "true"
    EndSection

    Section "Monitor"
        Identifier      "HDMI-1-0"
        Option          "LeftOf" "eDP"
        Option          "DPMS" "true"
    EndSection

    Section "Device"
        Identifier      "AMD Card"
        Driver          "amdgpu"
        BusId           "PCI:5:0:0"
        Option          "Monitor-eDP" "eDP"
        Option          "DRI" "3"
    EndSection

    Section "Device"
        Identifier      "Nvidia Card"
        Driver          "nvidia"
        BusId           "PCI:1:0:0"
        Option          "Monitor-HDMI-1-0" "HDMI-1-0"
        Option          "DRI" "3"
    EndSection
  '';
}
