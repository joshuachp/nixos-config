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

      # Etc is an overlay, the keys must be stored else were
      hostKeys = [
        {
          bits = 4096;
          path = "/var/lib/ssh/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          path = "/var/lib/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };

  };
}
