{ config, neovim-config, ... }: {
  # Default user
  imports = [ ./joshuachp.nix ];
  config = {
    # Default text editor
    programs.neovim.enable = true;

    users = {
      # Do not permit users to change
      mutableUsers = false;

      groups = {
        # Group with access to the nix secrets
        nix-keys = {
          gid = 3000;
        };
        share-dir = {
          gid = 3001;
        };
      };

      users.root.hashedPasswordFile = config.sops.secrets.users_passwords_root.path;
    };

    # Environment variables, useful for the root user
    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    # Home manager configuration
    home-manager = {
      useUserPackages = true;
      useGlobalPkgs = true;
      sharedModules = [
        ../options
        # Flake input
        neovim-config.homeManagerModules.default
        {
          # Make sure the systemConfig is the same for home manager
          config.systemConfig = config.systemConfig;
        }
      ];
    };
  };
}
