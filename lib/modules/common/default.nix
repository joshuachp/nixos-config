# Package dependent library functions
{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./math.nix
    ./list.nix
    ./string.nix
  ];
  config = {
    lib.config =
      let
        libCfg = config.lib.config;
      in
      {
        wrapGLIntel =
          name: binary:
          (pkgs.writeShellScriptBin name ''
             #!/usr/bin/env bash

             set -euo pipefail

            ${pkgs.nixgl.nixGLIntel}/bin/nixGLIntel ${binary} $@
          '');

        mkBase16Theme =
          template:
          let
            cfg = config.systemConfig.theme.base16;
            theme = cfg.themes."${cfg.default}";
          in
          template theme;

        theme = {
          hexToRgb =
            hex:
            assert (builtins.match "^[a-zA-Z0-9]{6}$" hex) == [ ];
            lib.pipe hex [
              (libCfg.string.chunks 2)
              (builtins.map libCfg.math.hexToDec)
            ];
        };
      };
  };
}
