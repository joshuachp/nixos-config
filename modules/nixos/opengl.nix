# OpenGL and hardware acceleration
{ config
, lib
, pkgs
, ...
}: {
  options = {
    nixosConfig.hardware.opengl = {
      enable = lib.options.mkOption {
        default = false;
        defaultText = "Enables OpenGL";
        description = "Enable OpenGL hardware accelleration";
        type = lib.types.bool;
      };
      intel = lib.options.mkOption {
        default = false;
        defaultText = "Enables Intel OpenGL";
        description = "Enable Intel packages for OpenGL and Vulkan hardware accelleration";
        type = lib.types.bool;
      };
      amd = lib.options.mkOption {
        default = false;
        defaultText = "Enables Amd OpenGL";
        description = "Enable Amd packages for OpenGL and Vulkan hardware accelleration";
        type = lib.types.bool;
      };
    };
  };
  config =
    let
      cfg = config.nixosConfig.hardware.opengl;
    in
    lib.mkIf cfg.enable {
      services.xserver.videoDrivers = [ "modesetting" ];
      hardware.opengl = {
        enable = true;

        driSupport = true;
        driSupport32Bit = true;

        extraPackages = with pkgs; [
          # Vulkan
          vulkan-extension-layer
          vulkan-validation-layers
        ] ++ lib.lists.optionals cfg.intel [
          intel-media-driver
          intel-compute-runtime
          # Intel vaapi drivers
          vaapiIntel
          libvdpau-va-gl
        ] ++ lib.lists.optionals cfg.amd [
          # Vulkan
          amdvlk
          # Opencl
          rocmPackages.clr.icd
          rocmPackages.clr
        ];

        extraPackages32 = (lib.lists.optionals cfg.amd [
          pkgs.driversi686Linux.amdvlk
        ]) ++ (lib.lists.optionals cfg.intel [
          pkgs.pkgsi686Linux.vaapiIntel
        ]);
      };

    };
}
