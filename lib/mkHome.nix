# Function to configure home-manager
flakeInputs:
baseSystem:
name:
{ system ? baseSystem
, overlays ? [ ]
, modules ? [ ]
, nixpkgs ? flakeInputs.nixpkgs
, home-manager ? flakeInputs.home-manager
}:
let
  pkgs = import nixpkgs {
    inherit system overlays;

    config = {
      allowUnfree = true;
    };
  };
in
home-manager.lib.homeManagerConfiguration {
  inherit pkgs;

  extraSpecialArgs = {
    inherit (flakeInputs) self;
    inherit system flakeInputs;
    hostname = name;
  };

  modules = [
    ({ lib, config, ... }: {
      config = {
        systemConfig.homeManager.enable = lib.mkForce true;

        home = {
          # This value determines the Home Manager release that your
          # configuration is compatible with. This helps avoid breakage
          # when a new Home Manager release introduces backwards
          # incompatible changes.
          #
          # You can update Home Manager without changing this value. See
          # the Home Manager release notes for a list of state version
          # changes in each release.
          stateVersion = lib.mkDefault config.systemConfig.version;

          # Home Manager needs a bit of information about you and the
          # paths it should manage.
          username = name;
          homeDirectory = "/home/${name}";
        };
      };
    })

    # Lib
    ./modules/common
    # Overlays
    ../overlays
    # Options
    ../options

    # Secrets
    flakeInputs.privateConf.nixosModules.homeManagerSecrets

    # Default modules
    ../modules/common
    ../modules/homeManager
    #../users
    ../homes/${name}
  ] ++ modules;
}
