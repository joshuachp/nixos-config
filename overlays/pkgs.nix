{
  self,
  config,
  pkgs,
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

          mattermost-desktop =
            if config.systemConfig.desktop.wayland then
              config.lib.config.wrapElectronWayland super.mattermost-desktop
            else
              super.mattermost-desktop;
          packages = self.packages.${system};
        in
        {
          astartectl = pkgs.callPackage ../packages/astartectl.nix { };
          customLocale = pkgs.callPackage ../packages/customLocale.nix { };
          inherit (unstablePkgs) cargo-edit jujutsu proton-ge-bin;
          inherit
            committed
            committedWithDefault
            mattermost-desktop
            ;
          inherit (packages) jj-p;
        }
      )
    ];
  };
}
