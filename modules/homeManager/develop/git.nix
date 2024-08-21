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
    in
    lib.mkIf cfg.enable {
      home.packages = [ pkgs.difftastic ];

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

          help.autocorrect = "prompt";

          status.submoduleSummary = true;

          # Diff config
          diff = {
            tool = "difftastic";
            algorithm = "histogram";
            # show diff in sub-modules
            submodule = "log";
          };

          difftool = {
            prompt = false;
            difftastic.cmd = "difft \"$LOCAL\" \"$REMOTE\"";
          };
          # Use a pager for large output, just like other git commands
          pager.difftool = true;

          # recurse in sub-modules for example while switching branches
          submodule.recurse = true;

          pull.rebase = "interactive";
          push.autoSetupRemote = true;

          fetch = {
            prune = true;
            prunetags = true;
          };

          merge = {
            tool = "nvimdiff";
            conflictStyle = "zdiff3";
          };

          rebase = {
            # easier fix-up
            autosquash = true;
            autostash = true;
            # prevent deleting commits during rebase, you have to drop them instead
            missingCommitsCheck = "error";
            # easier rebase with stacked branches
            updateRefs = true;
          };

          branch.sort = "-committerdate";

          commit.verbose = true;

          log.date = "iso";

          url."git@github.com:".pushInsteadOf = "https://github.com/";
        };

        includes = [
          {
            condition = "gitdir:~/share/repos/seco/";
            contents = {
              user = {
                inherit (privCfg.joshuaSeco) email;
                signingkey = privCfg.joshuaSeco.pgpPubKey;
              };
            };
          }
        ];
      };
    };
}
