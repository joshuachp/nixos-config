{ config
, pkgs
, ...
}: {
  config = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.joshuachp = {
      isNormalUser = true;
      description = "Joshua Chapman";
      extraGroups = [ "wheel" "networkmanager" "nix-keys" "audio" "video" ];
      passwordFile = config.sops.secrets.users_passwords_joshuachp.path;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPSZcROTKTFoBg//2EdP2aBq9gFzYFSbwRugF/mG1EOx cardno:14 250 662"
      ];
    };

    # Home manager configuration, this is for stuff that will be difficult to achieve with only
    # nixos modules
    home-manager.users.joshuachp = { config, pkgs, lib, ... }: {
      config = {
        home.stateVersion = config.systemConfig.version;
        dconf.settings = lib.mkIf config.systemConfig.desktopEnabled {
          # Terminal shortcut for Gnome
          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            name = "Terminal";
            binding = "<Super>Return";
            command = "alacritty";
          };
          "org/gnome/settings-daemon/plugins/media-keys" = {
            custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
          };
        };
      };
    };
  };
}
