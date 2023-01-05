{ config
, pkgs
, ...
}: {
  config = {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.joshuachp = {
      isNormalUser = true;
      description = "Joshua Chapman";
      extraGroups = [ "wheel" "networkmanager" ];
      passwordFile = config.sops.secrets.users_passwords_joshuachp.path;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPSZcROTKTFoBg//2EdP2aBq9gFzYFSbwRugF/mG1EOx cardno:14 250 662"
      ];
    };
  };
}
