# Shell aliases
_:
let
  abbreviations = {
    # Git
    ga = "git add";
    gaa = "git add -A";
    gap = "git add --patch";
    gc = "git commit -v";
    gcm = "git commit -v -m";
    gca = "git commit -v -a";
    "gc!" = "git commit -v --amend";
    "gca!" = "git commit -v -a --amend";
    gs = "git switch";
    gsc = "git switch --create";
    gst = "git status";
    gdc = "git diff --cached";
    gd = "git diff";
    gdt = "git difftool";
    gdtc = "git difftool --cached";
    gfp = "git fetch --prune";
    gl = "git pull";
    gp = "git push";
    gpf = "git push --force-with-lease";
    glg = "git log --graph";
    glga = "git log --graph --all";
    glp = "git log -p";
    gwa = "git worktree add";
    gwc = "git worktree add --checkout";
    gwr = "git worktree remove";
    glo = "git log --oneline";
    grc = "git rebase --continue";
    # Kubernetes
    k = "kubectl";
    kgp = "kubectl get pods";
    kgn = "kubectl get nodes";
    kgs = "kubectl get services";
    # Jujutsu
    jn = "jj new 'trunk()'";
    jc = "jj commit";
    jpa = "jj git push --all";
    jfa = "jj git fetch --all-remotes";
    jrm = "jj rebase -d 'trunk()'";
    jbc = "jj bookmark create";
    jbcp = "jj bookmark create -r '@-'";
  };
  ls = {
    # Eza as ls
    ls = "eza --group-directories-first --group --hyperlink";
    ll = "ls -lh";
    la = "ls -la";
    lt = "eza --group-directories-first --group --tree";
  };
  aliases = {
    # Better options for core packages
    # Less intrusive than -i but still secure
    rm = "rm -I";
    q = "exit";
    diff = "diff --color=auto";
    grep = "grep --color=auto";
    mv = "mv -i";
    cp = "cp -i";
    free = "free -h";

    # Git
    gpsup = "git push --set-upstream origin \"$(git branch --show-current)\"";

    # Utils
    cdtmp = "cd (mktemp -d)";
    nvimdiff = "nvim -d";
    open = "xdg-open";

    # Config
    chezmoi-cd = "cd \"$(chezmoi source-path)\"";

    # Bluetooth
    btoff = "bluetoothctl power off";

    # Task warrior
    taskw = "task project:work";
  };
  shAliases = {
    # Utils
    mkdate = "mkdir \"$(date +%Y-%m-%d)\"";
  };
in
{
  config = {
    home.shellAliases = aliases // shAliases // ls;

    programs = {
      fish.shellAbbrs = abbreviations;
      bash.shellAliases = abbreviations;
      zsh.shellAliases = abbreviations;
      nushell.shellAliases =
        abbreviations // aliases // { mkdate = "mkdir (date now | format date %F)"; };
    };
  };
}
