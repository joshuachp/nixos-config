{ _, ... }: {
  imports = [ ./hardware-configuration.nix ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "joshuachp";
    startMenuLaunchers = true;
  };

  networking.hostName = "nixos-wsl";

  # Hostname
  environment.etc."wsl.conf".text = ''
    [network]
    hostname = nixos-wsl
  '';

  security.sudo.wheelNeedsPassword = false;
}
