# Package dependent library functions
{ pkgs, lib, ... }:
{
  config = {
    lib.config = {
      wrapGLIntel =
        name: binary:
        (pkgs.writeShellScriptBin name ''
           #!/usr/bin/env bash

           set -euo pipefail

          ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${binary} $@
        '');
      wrapElectronWayland =
        derivation:
        let
          name = lib.strings.getName derivation;
          exe = builtins.baseNameOf (lib.getExe derivation);
        in
        pkgs.symlinkJoin {
          name = "${name}-wayland";
          paths = [ derivation ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram "$out/bin/${exe}" \
              --set NIXOS_OZONE_WL 1
          '';
        };
    };
  };
}
