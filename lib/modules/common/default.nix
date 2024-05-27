# Package dependent library functions
{ pkgs, ... }:
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
    };
  };
}
