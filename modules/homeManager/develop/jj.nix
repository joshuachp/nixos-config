{
  config,
  lib,
  pkgs,
  ...
}:
{
  config =
    let
      cfg = config.systemConfig.develop;
      privCfg = config.privateConfig.users;
      toToml = pkgs.formats.toml { };
    in
    lib.mkIf cfg.enable {
      home.shellAliases = {
        jj = lib.getExe pkgs.jujutsuDynamicConfig;
      };
      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            inherit (privCfg.joshuachp) name email;
          };
          ui = {
            pager = [
              "less"
              "-FRX"
            ];
            diff-editor = "nvimdiff";
          };
          signing = {
            sign-all = true;
            backend = "gpg";
            key = privCfg.joshuachp.pgpPubKey;
          };
        };
      };
      home.file."share/seco/.jjconfig.toml".source = toToml.generate "jjconfig-custom-toml" {
        user = {
          inherit (privCfg.joshuaSeco) email;
        };
        signing = {
          key = privCfg.joshuaSeco.pgpPubKey;
        };
      };
    };
}
