# Deployment configuration
{ self, privateConf, deploy-rs }: {

  # Nixos cloud
  nodes.nixos-cloud =
    let
      inherit (self.nixosConfigurations) nixos-cloud;
      inherit (nixos-cloud.config.deploy) hostname port;
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

}
