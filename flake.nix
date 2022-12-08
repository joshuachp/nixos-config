{
  description = "NixOS configuration with flakes";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-22.11";
    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #  My packages
    jump = {
      url = "github:joshuachp/jump";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.fenix.follows = "fenix";
    };
    tools = {
      url = "github:joshuachp/tools";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.fenix.follows = "fenix";
    };
    note = {
      url = "github:joshuachp/note";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.fenix.follows = "fenix";
    };
  };
  outputs =
    { self
    , nixpkgs
    , nixos-hardware
    , nixos-wsl
    , fenix
    , flake-utils
    , neovim-nightly-overlay
    , ...
    } @ inputs:
    let
      mkSystem = import ./lib/mkSystem.nix;
      overlays = [
        fenix.overlays.default
        neovim-nightly-overlay.overlay
      ];
      systems = flake-utils.lib.system;
    in
    {
      # Nixos
      nixosConfigurations.nixos = mkSystem "nixos" {
        inherit inputs overlays;
        system = systems.x86_64-linux;
      };

      # Wsl
      nixosConfigurations.nixos-wsl = mkSystem "nixos-wsl" {
        inherit inputs overlays;
        system = systems.x86_64-linux;
      };
    };
}
