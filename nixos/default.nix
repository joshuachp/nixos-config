flakeInputs:
let
  nixosHardware = flakeInputs.nixos-hardware.nixosModules;
  inherit (flakeInputs.self.lib) mkSystem mkDesktop;
in
{
  # Nixos
  nixos = mkDesktop "nixos" {
    modules = [
      # Hardware configuration
      nixosHardware.common-cpu-amd
      nixosHardware.common-gpu-amd
      nixosHardware.common-gpu-nvidia-nonprime
      nixosHardware.common-pc-laptop
      nixosHardware.common-pc-laptop-ssd
      nixosHardware.common-pc-laptop-acpi_call
    ];
  };
  # Work
  burkstaller = mkDesktop "burkstaller" {
    modules = [
      # Hardware configuration
      nixosHardware.common-cpu-intel
      nixosHardware.common-pc
      nixosHardware.common-pc-ssd
    ];
  };
  # Cloud
  nixos-cloud = mkSystem "nixos-cloud" {
    modules = [
      flakeInputs.disko.nixosModules.disko
    ];
  };
  # Cloud 2
  nixos-cloud-2 = mkSystem "nixos-cloud-2" {
    system = "aarch64-linux";
    modules = [
      flakeInputs.disko.nixosModules.disko
    ];
  };
  # Kuma
  kuma = mkSystem "kuma" {
    system = "aarch64-linux";
    modules = [
      flakeInputs.disko.nixosModules.disko
    ];
  };
  # Tabour
  tabour = mkSystem "tabour" {
    modules = [
      nixosHardware.common-cpu-intel
      nixosHardware.common-pc
      nixosHardware.common-pc-ssd
      flakeInputs.disko.nixosModules.disko
    ];
  };
}
