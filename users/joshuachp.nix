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
      hashedPasswordFile = config.sops.secrets.users_passwords_joshuachp.path;
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = [
        config.privateConfig.ssh.publicKey
      ];
    };

    programs.fish.enable = true;

    # Home manager configuration, this is for stuff that will be difficult to achieve with only
    # nixos modules
    home-manager.users.joshuachp = { config, pkgs, lib, ... }: {
      imports = [
        ../modules/homeManager/desktop/gnome.nix
        ../modules/homeManager/nvim.nix
        ../modules/homeManager/syncthing.nix
        ../modules/homeManager/gpg.nix
      ];
      config = {
        home.stateVersion = config.systemConfig.version;
      };
    };
  };
}
