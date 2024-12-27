{
  hostname,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./cli.nix
    ./hardware
    ./localization.nix
    ./networking
    ./nix
    ./security.nix
    ./services.nix
    ./wireguard
  ];
  config = {
    networking.hostName = hostname;

    system = {
      stateVersion = config.systemConfig.version;

      # Auto-update
      autoUpgrade = {
        enable = false;
        allowReboot = false;
      };

      # Etc overlay
      etc.overlay = {
        enable = true;
        mutable = true;
      };
    };

    boot = {
      # LTS kernel
      kernelPackages = pkgs.linuxPackages_6_12;

      # clean /tmp on boot
      tmp.cleanOnBoot = true;

      # Use systemd for booting
      initrd = {
        systemd.enable = true;
        services.lvm.enable = true;
      };
    };

    # Console configuration
    console = {
      earlySetup = true;
      font = "Lat2-Terminus16";
    };

    # Local timezone
    time.timeZone = "Europe/Rome";

    # Swap
    zramSwap.enable = true;
  };
}
