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
            #diff-editor = "nvim";
            diff-editor = ":builtin";
            default-command = "log";
            diff.tool = [
              "difft"
              "--color=always"
              "$left"
              "$right"
            ];
          };
          signing = {
            sign-all = true;
            backend = "gpg";
            key = privCfg.joshuachp.pgpPubKey;
          };
          template-aliases = {
            "signoff(author)" = ''
              "\n\nSigned-off-by: " ++ author.name() ++ " <" ++ author.email() ++ ">\n"
            '';
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
        templates = {
          draft_commit_description = ''
            concat(
              description,
              if(!description.contains("Signed-off-by"), signoff(self.committer())),
              surround(
                "\nJJ: This commit contains the following changes:\n", "",
                indent("JJ:     ", diff.stat(72)),
              ),
            )
          '';
        };
      };
    };
}
