# Environment variables
_:
{
  home = {
    # Additional paths
    sessionPath = [
      # Golang
      "$HOME/go/bin"
      # Local
      "$HOME/.local/bin"
      # Rust
      "$HOME/.cargo/bin"
      # PHP
      "$COMPOSER_VENDOR_DIR/bin"
    ];

    sessionVariables = {
      # XDG configuration
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DATA_HOME = "$HOME/.local/share";

      # Shell variables
      CDPATH = "$CDPATH:$HOME/share/repos";


      ##
      # History files
      #
      HISTFILE = "$XDG_CACHE_HOME/shell_history";
      SQLITE_HISTORY = "$XDG_CACHE_HOME/sqlite_history";
      LESSHISTFILE = "$XDG_CACHE_HOME/less_history";
      NODE_REPL_HISTORY = "$XDG_CACHE_HOME/node_repl_history";

      ##
      # Config files
      #
      # PostgreSQL
      PSQLRC = "$XDG_CONFIG_HOME/postgres/psqlrc";
      # Notmuch
      NOTMUCH_CONFIG = "$XDG_CONFIG_HOME/notmuch/config.conf";

      # Rust
      CARGO_TARGET_DIR = "$XDG_CACHE_HOME/cargo/target";

      # Golang
      GOBIN = "$HOME/go/bin";
      GOPATH = "$HOME/go";

      # NodeJS
      npm_config_userconfig = "$XDG_CONFIG_HOME/npm/config.ini";

      # Python
      PYLINTHOME = "/tmp/pylint.d";
      # Jupyter
      JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";

      # PHP
      COMPOSER_HOME = "$XDG_CONFIG_HOME/composer";
      COMPOSER_CACHE_DIR = "$XDG_CACHE_HOME/composer";
      COMPOSER_VENDOR_DIR = "$XDG_DATA_HOME/composer/vendor";


      # Browsers
      BROWSER = "firefox";
      TUI_BROWSER = "w3m";

      # Editor
      EDITOR = "nvim";
      # Visual
      VISUAL = "nvim";
      # Man Pager
      MANPAGER = "nvim +Man!";
      # Diff
      DIFFPROG = "nvim -d";

      # Terminal Emulator
      TERMINAL = "alacritty";

      # Tmux
      TMUX_PLUGIN_MANAGER_PATH = "$HOME/.tmux/plugins/tpm";

      # sxhkd
      SXHKD_SHELL = "/bin/sh";

      # XWAYLAND cursor theme
      # This tries to fix the disappearing cursor in xwayland and alacritty, see:
      # https://github.com/alacritty/alacritty/issues/4780
      XCURSOR_THEM = "Adwaita";

      # GPG config
      # GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";
      # SSH agent
      SSH_AUTH_SOCK = "$(gpgconf --list-dirs agent-ssh-socket)";
      # Age config
      SOPS_AGE_KEY_FILE = "/var/lib/age/keys.txt";

      # Sync
      SYNC_PATH = "$HOME/share/sync";
      # Notes
      NOTE_PATH = "$SYNC_PATH/notes";
      NOTE_SYNC = "sync-files";

      # hledger
      LEDGER_FILE = "$HOME/share/sync/ledger/$(date +%Y).journal";

      # Java
      # export JDK_HOME '/usr/lib/jvm/default'
      # export JAVA_HOME '/usr/lib/jvm/default-runtime'
    };
  };
}
