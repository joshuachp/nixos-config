{
  pkgs,
  lib,
  flakeInputs,
  system,
  ...
}:
{
  config = {
    nixpkgs.overlays = [
      (
        final: super:
        let
          unstablePkgs = import flakeInputs.nixpkgs-unstable { inherit system; };

          committed = pkgs.callPackage ../packages/committed.nix { };
          committedConfig = pkgs.writeText "committed.toml" ''
            subject_capitalized = false
            style = "conventional"
            no_fixup = false
          '';
          committedWithDefault = pkgs.writeShellApplication {
            name = "committed";
            runtimeInputs = [
              pkgs.git
              committed
            ];
            text = ''
              set -eEuo pipefail

              for arg in "$@"; do
                  if [[ $arg =~ ^-c|^--committed ]]; then
                      committed "$@"
                      return
                  fi
              done

              if git_root=$(git root 2>/dev/null) && [[ -f "$git_root/committed.toml" ]]; then
                  committed "$@"
                  return
              fi

              committed --config ${committedConfig} "$@"
            '';
          };
          jujutsuDynamicConfig =
            let
              jj = lib.getExe unstablePkgs.jujutsu;
            in
            pkgs.writeShellApplication {
              name = "jj-dynamic-config";
              runtimeInputs = [ unstablePkgs.jujutsu ];
              text = ''
                set -eEuo pipefail

                if [[ "$PWD" == "$HOME/share/repos/seco/"* ]]; then
                  ${jj} --config-toml "$(cat "$HOME/share/seco/.jjconfig.toml")" "$@"
                else
                  ${jj} "$@"
                fi
              '';
            };
        in
        {
          astartectl = pkgs.callPackage ../packages/astartectl.nix { };
          customLocale = pkgs.callPackage ../packages/customLocale.nix { };
          inherit (unstablePkgs) jujutsu cargo-edit;
          inherit committed committedWithDefault jujutsuDynamicConfig;
        }
      )
    ];
  };
}
