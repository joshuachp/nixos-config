# Enable SSH
{ lib, ... }:
{
  options = { };
  config = {
    services.openssh = {
      enable = true;
      openFirewall = lib.mkDefault false;

      settings = {
        X11Forwarding = false;
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        UseDns = false;
        # unbind gnupg sockets if they exists
        StreamLocalBindUnlink = true;
      };

      # Only allow system-level authorized_keys to avoid injections.
      authorizedKeysFiles = lib.mkForce [ "/etc/ssh/authorized_keys.d/%u" ];
    };

  };
}
