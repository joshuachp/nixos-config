# Shared QT configuration between NixOs and Home-Manager
{ lib
, config
, ...
}: {
  config =
    let
      cfg = config.systemConfig.desktop;
    in
    lib.mkIf cfg.enable {
      qt.enable = true;
    };
}
