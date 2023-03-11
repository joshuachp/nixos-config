{ pkgs }: with pkgs; [
  # Git
  git
  git-extras
  pre-commit

  # Code
  delta
  difftastic
  jq

  # Make
  entr
  gnumake

  # Other
  sqlite-interactive
  vale

  # Perf
  hyperfine

  # Debug
  gdb
  lldb

  # Various
  nodePackages.vim-language-server
  tree-sitter
]
