# Function to configure home-manager
{ inputs
, baseSystem
}: (
  name: { system ? baseSystem
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
          systemConfig.homeManager.enable = lib.mkForce true;

          # Home Manager needs a bit of information about you and the
          # paths it should manage.
          home.username = name;
          home.homeDirectory = "/home/${name}";
        };
      })

      # Overlays
      ../overlays
      # Options
      ../options

      # Secrets
      inputs.privateConf.nixosModules.homeManagerSecrets

      # Default modules
      ../modules/home-manager
      #../users
      ../homes/${name}
    ] ++ modules;
  }
)
