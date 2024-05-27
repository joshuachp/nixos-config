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

    # Package utilities
    flake-utils.url = "github:numtide/flake-utils";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixosAnywhere = {
      url = "github:numtide/nixos-anywhere";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        disko.follows = "disko";
      };
    };

    # Rust tools
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # My modules
    neovimConfig = {
      url = "github:joshuachp/neovim-config";
      inputs = {
        nixpkgs.follows = "nixpkgs-unstable";
        flake-utils.follows = "flake-utils";
      };
    };
    #  My packages
    jump = {
      url = "github:joshuachp/jump";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        crane.follows = "crane";
        rust-overlay.follows = "rust-overlay";
      };
    };
    tools = {
      url = "github:joshuachp/tools";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        crane.follows = "crane";
        rust-overlay.follows = "rust-overlay";
      };
    };
    note = {
      url = "github:joshuachp/note";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        crane.follows = "crane";
        rust-overlay.follows = "rust-overlay";
      };
    };

    # Private configuration
    privateConf = {
      url = "github:joshuachp/nixos-private-config";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    # Packages provided via flakes for having the latest version
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
      };
    };
    nil = {
      url = "github:oxalica/nil";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        rust-overlay.follows = "rust-overlay";
      };
    };
    nixgl = {
      url = "github:guibou/nixGL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      # Nixpkgs
      nixpkgs,
      privateConf,
      deploy-rs,
      flake-utils,
      neovimConfig,
      ...
    }@flakeInputs:
    let
      inherit (self.lib) mkHome;
    in
    {
      lib = import ./lib flakeInputs;
      nixosConfigurations = import ./nixos flakeInputs;

      # Home manager configuration
      homeConfigurations = {
        joshuachp = mkHome "joshuachp" { modules = [ neovimConfig.homeManagerModules.default ]; };
      };

      # Deployment configuration
      deploy = import ./deploy { inherit self privateConf deploy-rs; };
    }
    //
      # System dependant configurations
      flake-utils.lib.eachDefaultSystem (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          deploy = deploy-rs.packages.${system}.default;
          inherit (pkgs) callPackage;
        in
        {
          packages = import ./packages pkgs;
          checks = import ./checks pkgs;
          # This is highly advised, and will prevent many possible mistakes
          # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

          # Dev-Shell
          devShells.default = callPackage ./shells/default.nix { inherit deploy; };
        }
      );
}
