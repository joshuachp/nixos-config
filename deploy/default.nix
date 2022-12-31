# Deployment configuration
{ self, privateConf, deploy-rs }: {

  # Nixos cloud
  nodes.nixos-cloud =
    let
      nixos-cloud = self.nixosConfigurations.nixos-cloud;
      sshPort = nixos-cloud.config.deploy.port;
      hostname = nixos-cloud.config.deploy.hostname;
    in
    {
      inherit hostname;
      sshOpts = [ "-p" (toString sshPort) ];
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
