{
  description = "NixOS configuration with flakes";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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
        nixos-stable.follows = "nixpkgs";
        disko.follows = "disko";
      };
    };

    # Rust tools
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    crane.url = "github:ipetkov/crane";

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
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    # Packages provided via flakes for having the latest version
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      # Nixpkgs
      nixpkgs,
      flake-utils,
      ...
    }@flakeInputs:
    {
      lib = import ./lib flakeInputs;
      nixosConfigurations = import ./nixos flakeInputs;
    }
    # System dependant configurations
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs) callPackage;
      in
      {
        packages = import ./packages pkgs;
        checks = import ./checks pkgs;
        # Dev-Shell
        devShells.default = callPackage ./shells/default.nix { };
      }
    );
}
