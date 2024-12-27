{ config, modulesPath, ... }:
{
  imports = [
    ./k3s
    (modulesPath + "/profiles/minimal.nix")
  ];
  config = {
    assertions = [
      {
        assertion = config.systemd.network.networks != { };
        message = "networkd networks are not configured";
      }
    ];

    networking.useNetworkd = true;
    systemd.network.enable = true;

    # Smaller installs
    system.disableInstallerTools = true;
  };
}
