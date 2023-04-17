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
      imports = [
        ../modules/home-manager/gnome.nix
        ../modules/home-manager/syncthing.nix
      ];
      config = {
        home.stateVersion = config.systemConfig.version;
      };
    };
  };
}
