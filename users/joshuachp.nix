{ config
, pkgs
, ...
}: {
  config = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.joshuachp = {
      isNormalUser = true;
      description = "Joshua Chapman";
      extraGroups = [ "wheel" "networkmanager" "nix-keys" "audio" "video" "share-dir" ];
      passwordFile = config.sops.secrets.users_passwords_joshuachp.path;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH04ZDdmAFdHNO3kizLB383BeaZIYuqRnNwFx5uGNhIN openpgp:0x80D62E31"
      ];
    };

    # Home manager configuration, this is for stuff that will be difficult to achieve with only
    # nixos modules
    home-manager.users.joshuachp = { config, pkgs, lib, ... }: {
      config = {
        home.stateVersion = config.systemConfig.version;
        services.syncthing = lib.mkIf config.systemConfig.desktopEnabled {
          enable = true;
          tray.enable = true;
        };
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
