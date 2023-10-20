{
  description = "NixOS configuration with flakes";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # We use the unstable nixpkgs repo for some packages.
    # We use nixpkgs-unstable instead of nixos-unstable since we usually want to use the packages as
    # an overlay and not the nixos modules
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware configuration
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Package utilities
    flake-utils.url = "github:numtide/flake-utils";

    # Overlays
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My modules
    neovim-config = {
      url = "github:joshuachp/neovim-config";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    #  My packages
    jump = {
      url = "github:joshuachp/jump";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        fenix.follows = "fenix";
      };
    };
    tools = {
      url = "github:joshuachp/tools";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        fenix.follows = "fenix";
      };
    };
    note = {
      url = "github:joshuachp/note";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        fenix.follows = "fenix";
      };
    };
    pulseaudioMicState = {
      url = "github:joshuachp/pulseaudio-mic-state";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        fenix.follows = "fenix";
      };
    };

    # Private configuration
    privateConf = {
      url = "github:joshuachp/nixos-private-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Packages provided via flakes for having the latest version
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nil = {
      url = "github:oxalica/nil";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

  };
  outputs =
    { self
      # Nixpkgs
    , nixpkgs
    , nixpkgs-unstable
    , home-manager
      # Tools
    , deploy-rs
    , nil
    , nixgl
      # Modules
    , nixos-hardware
    , nixos-wsl
    , fenix
    , flake-utils
    , neovim-config
    , privateConf
      # Packages
    , jump
    , tools
    , note
    , pulseaudioMicState
    }@flakeInputs:
    let
      inherit (self.lib) mkHome;
    in
    {
      lib = import ./lib flakeInputs;
      nixosConfigurations = import ./nixos flakeInputs;

      # Home manager configuration
      homeConfigurations = {
        joshuachp = mkHome "joshuachp" {
          modules = [
            neovim-config.homeManagerModules.default
          ];
        };
      };

      # Deployment configuration
      deploy = import ./deploy { inherit self privateConf deploy-rs; };
    } //
    # System dependant configurations
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      deploy = deploy-rs.packages.${system}.default;
      inherit (pkgs) callPackage;
    in
    {
      checks = import ./checks pkgs;
      # This is highly advised, and will prevent many possible mistakes
      # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      # Dev-Shell
      devShells.default = callPackage ./shells/default.nix { inherit deploy; };
    });
}
