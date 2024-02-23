{ config
, lib
, pkgs
, ...
}:
{
  config =
    let
      cfg = config.systemConfig.develop;
      privCfg = config.privateConfig.users;
    in
    lib.mkIf cfg.enable {
      home.packages = [
        pkgs.difftastic
      ];

      programs.git = {
        enable = true;

        # User
        userName = privCfg.joshuachp.name;
        userEmail = privCfg.joshuachp.email;

        signing = {
          key = privCfg.joshuachp.pgpPubKey;
          # commit.gpgsign
          # tag.gpgsign
          signByDefault = true;
        };

        # `git dft` is less to type than `git difftool`.
        aliases = {
          dft = "difftool";
          prebase = "rebase -x 'pre-commit run --from-ref HEAD~ --to-ref HEAD'";
        };

        extraConfig = {
          init.defaultBranch = "main";
          format.signOff = true;
          rerere.enabled = true;

# Diff config
          diff = {
            tool = "difftastic";
            algorithm = "histogram";
          };
          difftool.pormpt = false;
          "difftool \"difftastric\"".cmd = ''
            difft "$LOCAL" "$REMOTE"
          '';
          # Use a pager for large output, just like other git commands
          pager.difftool = true;

          pull.rebase = "interactive";
          push.autoSetupRemote = true;

          merge = {
            tool = "nvimdiff";
            conflictStyle = "zdiff3";
          };
        };

        includes = [{
          condition = "gitdir:~/share/repos/seco";
          contents = {
            user = {
              inherit (privCfg.joshuaSeco) email;
              signingkey = privCfg.joshuaSeco.pgpPubKey;
            };
          };
        }];
      };
    };
}
