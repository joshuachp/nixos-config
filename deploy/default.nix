# Deployment configuration
{ self
, privateConf
, deploy-rs
}:
let
  inherit (self.nixosConfigurations) nixos-cloud nixos-cloud-2 kuma;
in
{

  nodes = {
    # Nixos cloud
    nixos-cloud =
      let
        inherit (nixos-cloud.config.privateConfig.deploy.nixos-cloud) hostname port;
      in
      {
        inherit hostname;
        sshOpts = [ "-p" (toString port) ];
        # Users
        sshUser = "root";
        user = "root";
        # So we do not have to upload all the constructs
        remoteBuild = true;

        profiles.cloud = {
          path = deploy-rs.lib.x86_64-linux.activate.nixos nixos-cloud;
        };
      };

    nixos-cloud-2 =
      let
        inherit (nixos-cloud-2.config.privateConfig.deploy.nixos-cloud-2) hostname port;
      in
      {
        inherit hostname;
        sshOpts = [ "-p" (toString port) ];
        # Users
        sshUser = "root";
        user = "root";
        # So we do not have to upload all the constructs
        remoteBuild = true;

        profiles.cloud = {
          path = deploy-rs.lib.aarch64-linux.activate.nixos nixos-cloud-2;
        };
      };

    # Kuma
    kuma = {
      hostname = "kuma.wg";
      # Users
      sshUser = "root";
      user = "root";
      # So we do not have to upload all the constructs
      remoteBuild = true;

      profiles.cloud = {
        path = deploy-rs.lib.aarch64-linux.activate.nixos kuma;
      };
    };
  };
}
