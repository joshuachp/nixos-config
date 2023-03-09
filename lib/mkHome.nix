# Function to configure a nixosSystem
name: { inputs
      , system
      , overlays ? [ ]
      , modules ? [ ]
      , nixpkgs ? inputs.nixpkgs
      , home-manager ? inputs.home-manager
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

  extraSpecialArgs = inputs // {
    inherit system;
    hostname = name;
  };

  modules = [
    ({ lib, ... }: {
      config = {
        systemConfig.homeManager.enabled = lib.mkForce true;

        # Home Manager needs a bit of information about you and the
        # paths it should manage.
        home.username = name;
        home.homeDirectory = "/home/${name}";
      };
    })

    # Options
    ../options

    # Default modules
    ../modules/home-manager
    #../users
    ../homes/${name}
  ] ++ modules;
}
