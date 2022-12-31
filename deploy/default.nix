# Deployment configuration
{ self, privateConf, deploy-rs }: {

  # Nixos cloud
  nodes.nixos-cloud =
    let
      nixos-cloud = self.nixosConfigurations.nixos-cloud;
      sshPorts = nixos-cloud.config.services.openssh.ports;
      sshOpts = builtins.concatMap (port: [ "-p" (toString port) ]) sshPorts;
      hostname = nixos-cloud.config.deploy.hostname;
    in
    {
      inherit sshOpts hostname;
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
