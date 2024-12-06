{
  config,
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

          jujutsu =
            let
              src = pkgs.fetchFromGitHub {
                owner = "martinvonz";
                repo = "jj";
                rev = "v0.24.0";
                hash = "sha256-XsD4P2UygZFcnlV2o3E/hRRgsGjwKw1r9zniEeAk758";
              };
            in
            unstablePkgs.jujutsu.overrideAttrs (
              final: super: {
                inherit src;
                version = "0.24.0";

                cargoDeps = super.cargoDeps.overrideAttrs {
                  inherit src;
                  outputHash = "sha256-5vqRfNRh4QD8CIGK1tgy61A+b6qrZS+OduiJf/ejiZw=";
                };

                postInstall =
                  let
                    jj = "$out/bin/jj";
                  in
                  ''
                    ${jj} util mangen > ./jj.1
                    installManPage ./jj.1

                    installShellCompletion --cmd jj \
                      --bash <(COMPLETE=bash ${jj}) \
                      --fish <(COMPLETE=fish ${jj}) \
                      --zsh <(COMPLETE=zsh ${jj})
                  '';
              }
            );
          jujutsuDynamicConfig =
            let
              jj = lib.getExe jujutsu;
            in
            pkgs.writeShellApplication {
              name = "jj-dynamic-config";
              runtimeInputs = [ jujutsu ];
              text = ''
                set -eEuo pipefail

                if [[ "$PWD" == "$HOME/share/repos/seco/"* ]]; then
                  ${jj} --config-toml "$(cat "$HOME/share/seco/.jjconfig.toml")" "$@"
                else
                  ${jj} "$@"
                fi
              '';
            };
          mattermost-desktop =
            if config.systemConfig.desktop.wayland then
              config.lib.config.wrapElectronWayland super.mattermost-desktop
            else
              super.mattermost-desktop;
        in
        {
          astartectl = pkgs.callPackage ../packages/astartectl.nix { };
          customLocale = pkgs.callPackage ../packages/customLocale.nix { };
          inherit (unstablePkgs) cargo-edit;
          inherit
            jujutsu
            committed
            committedWithDefault
            jujutsuDynamicConfig
            mattermost-desktop
            ;
        }
      )
    ];
  };
}
