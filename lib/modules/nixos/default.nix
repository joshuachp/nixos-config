# Nixos system dependent functions
{ lib
, ...
}:
{
  config = {
    lib.config = {
      /**
       * Sets the defaults for the systemd-network interfaces configuration.
       *
       * ```nix
       * mkNetworkCfg { "enp1s0" = { linkConfig.RequiredForOnline = "no"; }; }
       * => { "11-enp1s0" = { matchConfig.Name = "enp1s0"; networkingConfig.RequiredForOnline = "no"; ...}; }
       * ```
       */
      mkNetworkCfg = config:
        lib.pipe config [
          (lib.mapAttrsToList (name: value: {
            inherit name;
            value = lib.recursiveUpdate
              # Defaults
              {
                matchConfig.Name = name;
                networkConfig.DHCP = "yes";
                dhcpV4Config = {
                  UseDNS = false;
                };
                dhcpV6Config = {
                  UseDNS = false;
                };
              }
              # merged with the configuration
              value;
          }))
          # Enumerate the configs
          (lib.imap (i: v: {
            name = "${toString (10+i)}-${v.name}";
            inherit (v) value;
          }))
          builtins.listToAttrs
        ];
    };
  };
}
