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
      # inputs.nixpkgs.follows = "nixpkgs-unstable";
      # FIXME: this is a temporary fix for the build failing
      inputs.nixpkgs.url = "github:nixos/nixpkgs?rev=fad51abd42ca17a60fc1d4cb9382e2d79ae31836";
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

    # Private configuration
    privateConf = {
      url = "github:joshuachp/nixos-private-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self
      # Nixpkgs
    , nixpkgs
    , nixpkgs-unstable
      # Tools
    , deploy-rs
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
    } @ inputs:
    let
      mkSystem = import ./lib/mkSystem.nix;
      overlays = [
        fenix.overlays.default
        (import ./overlays)
      ];
      baseSystem = flake-utils.lib.system.x86_64-linux;
      arm-system = flake-utils.lib.system.aarch64-linux;
    in
    {
      nixosConfigurations = {
        # Nixos
        nixos = mkSystem "nixos" {
          inherit inputs overlays;
          system = baseSystem;
          modules = [
            neovim-config.nixosModules.default
          ];
        };
        # Wsl
        nixos-wsl = mkSystem "nixos-wsl" {
          inherit inputs overlays;
          system = baseSystem;
          modules = [
            neovim-config.nixosModules.default
          ];
        };
        # Work
        nixos-work = mkSystem "nixos-work" {
          inherit inputs;
          system = baseSystem;
          modules = [
            neovim-config.nixosModules.default
          ];
          overlays = [
            (self: super: {
              jetbrains = super.jetbrains // {
                jetbrains.phpstorm = super.jetbrains.phpstorm.overrideAttrs (old: {
                  patches = (old.patches or [ ]) ++ [
                    ./patches/phpstorm.patch
                  ];
                });
              };
            })
          ] ++ overlays;
        };
        # Raspberry PI 3B
        nixos-rpi = mkSystem "nixos-rpi" {
          inherit inputs overlays;
          # System of the RPi 3B is ARM64
          system = arm-system;
        };
        # Cloud
        nixos-cloud = mkSystem "nixos-cloud" {
          inherit inputs overlays;
          system = baseSystem;
          modules = [ privateConf.nixosModules.nixos-cloud ];
        };
      };

      # Deployment configuration
      deploy = import ./deploy { inherit self privateConf deploy-rs; };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

      # Dev-Shell
      devShells.${baseSystem}.default =
        let
          pkgs = nixpkgs.legacyPackages.${baseSystem};
        in
        pkgs.mkShell {
          buildInputs = with pkgs; [
            deploy-rs.packages.${baseSystem}.default

            pre-commit
            nixpkgs-fmt
            statix
          ];
        };
    };
}
