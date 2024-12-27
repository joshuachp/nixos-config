# Package dependent library functions
{ pkgs, lib, ... }:
{
  config = {
    lib.config = {
      wrapElectronWayland =
        derivation:
        let
          name = lib.strings.getName derivation;
          fullExe = lib.getExe derivation;
          exe = builtins.baseNameOf (lib.getExe derivation);
        in
        pkgs.symlinkJoin {
          name = "${name}-wayland";
          paths = [ derivation ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram "$out/bin/${exe}" \
              --set NIXOS_OZONE_WL 1

            filesWithRefs=$(grep -wl '${fullExe}' -r '${derivation}')
            for f in "$filesWithRefs"; do
              file="''${f#${derivation}}"

              rm "$out/$file"

              substitute "$f" "$out/$file" \
                --replace-fail '${fullExe}' "$out/bin/${exe}"
            done
          '';
        };
    };
  };
}
