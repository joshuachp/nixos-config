{
  description = "NixOS configuration with flakes";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO: this is an hack there should be a better way to import this
    nerd-font-symbols.url = "path:/home/joshuachp/share/repos/github/nixos-config/packages/nerd-font-symbols";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jump.url = "github:joshuachp/jump";
  };
  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    fenix,
    flake-utils,
    neovim-nightly-overlay,
    ...
  } @ attrs: {
    # Nixos
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem (let
      system = flake-utils.lib.system.x86_64-linux;
    in {
      inherit system;
      specialArgs = attrs // {inherit system;};

      modules = [
        ./cli
        ./configuration.nix
        ./desktop
        ./develop
        ./system/nixos
        ./system/common/network
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-pc-laptop
        nixos-hardware.nixosModules.common-pc-laptop-hdd
        nixos-hardware.nixosModules.common-pc-laptop-acpi_call
      ];
    });

    # Wsl
    nixosConfigurations.nixos-wsl = nixpkgs.lib.nixosSystem {
      system = flake-utils.lib.system.x86_64-linux;
      specialArgs = attrs;

      modules = [./cli ./configuration.nix ./develop ./system/nixos-wsl];
    };
  };
}
