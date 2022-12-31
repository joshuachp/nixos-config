{
  description = "NixOS configuration with flakes";
  inputs = {
    # x86_64-linux and aarch64-linux support
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    # We use the unstable nixpkgs repo for some packages.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # deploy
    deploy-rs = {
      url = "github:serokell/deploy-rs";
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
      # Nixpkgs
    , nixpkgs
    , nixpkgs-unstable
      # Modules
    , deploy-rs
    , nixos-hardware
    , nixos-wsl
    , fenix
    , flake-utils
    , neovim-config
    , ...
    } @ inputs:
    let
      mkSystem = import ./lib/mkSystem.nix;
      overlays = [
        fenix.overlays.default
        (import ./overlays)
      ];
      base-system = flake-utils.lib.system.x86_64-linux;
      arm-system = flake-utils.lib.system.aarch64-linux;
    in
    {
      nixosConfigurations = {
        # Nixos
        nixos = mkSystem "nixos" {
          inherit inputs overlays;
          system = base-system;
          modules = [
            neovim-config.nixosModules.default
          ];
        };
        # Wsl
        nixos-wsl = mkSystem "nixos-wsl" {
          inherit inputs overlays;
          system = base-system;
          modules = [
            neovim-config.nixosModules.default
          ];
        };
        # Raspberry PI 3B
        nixos-rpi = mkSystem "nixos-rpi" {
          inherit inputs overlays;
          # System of the RPi 3B is ARM64
          system = arm-system;
        };
      };


      # Dev-Shell
      devShells.${base-system}.default =
        let
          pkgs = nixpkgs.legacyPackages.${base-system};
        in
        pkgs.mkShell {
          buildInputs = with pkgs; [
            deploy-rs.packages.${base-system}.default

            pre-commit
            nixpkgs-fmt
            statix
          ];
        };
    };
}
