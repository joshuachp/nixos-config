{ config, ... }: {
  # Default user
  imports = [ ./joshuachp.nix ];
  config = {
    # Default text editor
    programs.neovim.enable = true;

    # Environment variables, useful for the root user
    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    users.users.root.passwordFile = config.sops.secrets.users_passwords_root.path;
  };
}
