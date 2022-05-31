# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: {
  # Set your time zone.
  time.timeZone = "Europe/Rome";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "it";
  };

  # Environment variables, useful for the root user
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joshuachp = {
    isNormalUser = true;
    description = "Joshua Chapman";
    extraGroups = ["wheel" "networkmanager"];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPSZcROTKTFoBg//2EdP2aBq9gFzYFSbwRugF/mG1EOx cardno:14 250 662"
    ];
  };

  # Manpages
  documentation = {
    enable = true;
    dev.enable = true;
    nixos.enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
  };
  environment.systemPackages = [pkgs.man-pages pkgs.man-pages-posix];

  # Enable unfreee pacakges
  nixpkgs.config.allowUnfree = true;
  system = {
    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    stateVersion = "22.05"; # Did you read the comment?

    # Autoupdate
    autoUpgrade = {
      enable = false;
      allowReboot = false;
    };
  };

  # Flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
}
