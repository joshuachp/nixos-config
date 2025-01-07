flakeInputs:
let
  nixosHardware = flakeInputs.nixos-hardware.nixosModules;
  privateConf = flakeInputs.privateConf.nixosModules;
  inherit (flakeInputs.self.lib) mkDesktop mkServer;
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
  nixos-cloud = mkServer "nixos-cloud" {
    modules = [
      privateConf.nixosCloud
    ];
  };
  # Cloud 2
  nixos-cloud-2 = mkServer "nixos-cloud-2" {
    system = "aarch64-linux";
    modules = [
      privateConf.nixosCloud2
    ];
  };
  # Kuma
  kuma = mkServer "kuma" {
    system = "aarch64-linux";
    modules = [
      privateConf.kuma
    ];
  };
  # Tabour
  tabour = mkServer "tabour" {
    modules = [
      nixosHardware.common-cpu-intel
      nixosHardware.common-gpu-intel
      nixosHardware.common-pc
      nixosHardware.common-pc-ssd
      privateConf.tabour
    ];
  };
  # The crab
  kani = mkServer "kani" {
    modules = [
      nixosHardware.common-cpu-intel
      nixosHardware.common-pc
      nixosHardware.common-pc-laptop
      nixosHardware.common-pc-laptop-hdd
      nixosHardware.common-gpu-nvidia-nonprime
      privateConf.kani
    ];
  };
}
