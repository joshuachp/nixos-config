# Wireguard configuration
{ lib
, config
, ...
}:
let
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib) types;
  sopsSecrets = config.sops.secrets;
  privateCfg = config.privateConfig.wireguard;
in
{
  imports = [
    ./client.nix
    ./server.nix
  ];
  options = {
    nixosConfig.wireguard = {
      client = mkEnableOption "Wireguard client";
      server = mkEnableOption "Wireguard server";
      hostConfig = mkOption {
        default = { };
        description = "Host configurations for the Wireguard clients for each hostname";
        type = types.attrsOf
          (types.submodule {
            options = {
              privateKey = mkOption {
                description = "Private key of the Wireguard client";
                type = types.path;
              };
              publicKey = mkOption {
                description = "Public key of the Wireguard client";
                type = types.str;
              };
              addressIpv4 = mkOption {
                description = "IPv4 address for the Wireguard client";
                type = types.str;
              };
              addressIpv6 = mkOption {
                description = "IPv6 address for the Wireguard client";
                type = types.str;
              };
            };
          });
      };
    };
  };
  config = {
    nixosConfig.wireguard = {
      hostConfig = {
        nixos = {
          privateKey = sopsSecrets.wireguard_nixos_private.path;
          publicKey = privateCfg.nixosPublicKey;
          addressIpv4 = "10.0.0.1";
          addressIpv6 = "fdc9:281f:04d7:9ee9::1";
        };
        nixos-cloud = {
          privateKey = sopsSecrets.wireguard_nixos_cloud_private.path;
          publicKey = privateCfg.nixosCloudPublicKey;
          addressIpv4 = "10.0.0.2";
          addressIpv6 = "fdc9:281f:04d7:9ee9::2";
        };
        burkstaller = {
          privateKey = sopsSecrets.wireguard_nixos_work_private.path;
          publicKey = privateCfg.nixosWorkPublicKey;
          addressIpv4 = "10.0.0.4";
          addressIpv6 = "fdc9:281f:04d7:9ee9::4";
        };
      };
    };
  };
}
