{ config, ... }: {
  # Default user
  imports = [ ./joshuachp.nix ];
  config = {
    # Default text editor
    programs.neovim.enable = true;

    users.groups = {
      # Group with access to the nix secrets
      nix-keys = {
        gid = 3000;
      };
    };

    # Environment variables, useful for the root user
    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    users.users.root.passwordFile = config.sops.secrets.users_passwords_root.path;
  };
}
