{
  description = "NixOS configuration with flakes";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO: this is an hack there should be a better way to import this
    nerd-font-symbols = {
      url = "path:/home/joshuachp/share/repos/github/nixos-config/packages/nerd-font-symbols";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jump = {
      url = "github:joshuachp/jump";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    note = {
      url = "github:joshuachp/note";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
      inputs.fenix.follows = "fenix";
    };
  };
  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    nixos-wsl,
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
        ./hacking
        ./nix
        ./system/common/network
        ./system/nixos
        nixos-hardware.nixosModules.common-cpu-amd
        nixos-hardware.nixosModules.common-gpu-amd
        nixos-hardware.nixosModules.common-pc-laptop
        nixos-hardware.nixosModules.common-pc-laptop-hdd
        nixos-hardware.nixosModules.common-pc-laptop-acpi_call
      ];
    });

    # Wsl
    nixosConfigurations.nixos-wsl = nixpkgs.lib.nixosSystem (let
      system = flake-utils.lib.system.x86_64-linux;
    in {
      inherit system;
      specialArgs = attrs // {inherit system;};

      modules = [
        ./cli
        ./configuration.nix
        ./develop
        ./nix
        ./system/nixos-wsl
        nixos-wsl.nixosModules.wsl
      ];
    });
  };
}
