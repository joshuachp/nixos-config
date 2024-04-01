{ pkgs
, ...
}:
{
  config = {
    nixpkgs.overlays = [
      (super: final:
        let
          committed = pkgs.callPackage ../packages/committed.nix { };
          committedConfig = pkgs.writeText "committed.toml" ''
            subject_capitalized = false
            style = "conventional"
            no_fixup = false
          '';
          committedWithDefault = pkgs.writeShellApplication {
            name = "committed";
            runtimeInputs = [ pkgs.git committed ];
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
        in
        {
          astartectl = pkgs.callPackage ../packages/astartectl.nix { };
          inherit committed committedWithDefault;
        })
    ];
  };
}
