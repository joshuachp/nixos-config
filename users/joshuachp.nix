{ config
, pkgs
, ...
}: {
  config = {
    users.groups. joshuachp = {
      gid = 1000;
    };
    users.users.joshuachp = {
      uid = 1000;
      isNormalUser = true;
      description = "Joshua Chapman";
      extraGroups = [
        "users"
        "wheel"
        "networkmanager"
        "nix-keys"
        "audio"
        "video"
        "share-dir"
      ];
      group = "joshuachp";
      passwordFile = config.sops.secrets.users_passwords_joshuachp.path;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        config.privateConfig.ssh.publicKey
      ];
    };

    # Since the user shell is zsh, we need to enable it
    programs.zsh.enable = true;

    # Home manager configuration, this is for stuff that will be difficult to achieve with only
    # nixos modules
    home-manager.users.joshuachp = { config, pkgs, lib, ... }: {
      imports = [
        ../modules/home-manager/gnome.nix
        ../modules/home-manager/nvim.nix
        ../modules/home-manager/syncthing.nix
        ../modules/home-manager/gpg.nix
      ];
      config = {
        home.stateVersion = config.systemConfig.version;
      };
    };
  };
}
