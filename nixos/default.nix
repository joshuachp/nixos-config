flakeInputs:
let
  nixosHardware = flakeInputs.nixos-hardware.nixosModules;
  inherit (flakeInputs.self.lib) mkSystem mkDesktop mkServer;
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
    ];
  };
  # Work
  burkstaller = mkDesktop "burkstaller" {
    modules = [
      # Hardware configuration
      nixosHardware.common-cpu-intel
      nixosHardware.common-gpu-intel
      nixosHardware.common-pc
      nixosHardware.common-pc-ssd
    ];
  };
  # Cloud
  nixos-cloud = mkServer "nixos-cloud" { };
  # Cloud 2
  nixos-cloud-2 = mkServer "nixos-cloud-2" {
    system = "aarch64-linux";
  };
  # Kuma
  kuma = mkServer "kuma" {
    system = "aarch64-linux";
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
  # The crab
  kani = mkSystem "kani" {
    modules = [
      nixosHardware.common-cpu-intel
      nixosHardware.common-pc
      nixosHardware.common-pc-laptop
      nixosHardware.common-pc-laptop-hdd
      nixosHardware.common-gpu-nvidia-nonprime
      flakeInputs.disko.nixosModules.disko
    ];
  };
}
