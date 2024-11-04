# OpenGL and hardware acceleration
{
  config,
  lib,
  pkgs,
  ...
}:
{
  options =
    let
      cfgSystem = config.systemConfig;
      inherit (lib) mkOption types;
    in
    {
      nixosConfig.hardware.opengl = {
        enable = mkOption {
          default = cfgSystem.desktop.enable;
          description = "Enable OpenGL hardware acceleration";
          type = lib.types.bool;
        };
        gpu = mkOption {
          description = "List of the system GPU";
          type = types.listOf (
            types.enum [
              "amd"
              "intel"
            ]
          );
        };
      };
    };
  config =
    let
      cfg = config.nixosConfig.hardware.opengl;
      amd = builtins.elem "amd" cfg.gpu;
      intel = builtins.elem "intel" cfg.gpu;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.enable && (cfg.gpu != [ ]);
          message = "Select a gpu for OpenGL";
        }
      ];
      services.xserver.videoDrivers = [ "modesetting" ];
      hardware = {
        opengl = {
          enable = true;

          driSupport = true;
          driSupport32Bit = true;

          extraPackages =
            (with pkgs; [
              # Vulkan
              vulkan-extension-layer
              vulkan-validation-layers
            ])
            ++ lib.optionals intel (
              with pkgs;
              [
                intel-media-driver
                intel-compute-runtime
                # imported in nixos-hardware
                # intel-vaapi-driver
                libvdpau-va-gl
              ]
            );

          extraPackages32 = lib.optionals intel [
            pkgs.pkgsi686Linux.intel-media-driver
            # imported in nixos-hardware
            # pkgs.pkgsi686Linux.intel-vaapi-driver
          ];
        };

        amdgpu = lib.mkIf amd {
          opencl.enable = true;
          initrd.enable = true;
          amdvlk = {
            enable = true;
            support32Bit.enable = true;
          };
        };
      };
    };
}
