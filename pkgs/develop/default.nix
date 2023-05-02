{ pkgs }: with pkgs; [
  # Git
  git
  git-extras
  pre-commit

  # Code
  dprint
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
  rr
  gdb
  lldb

  # Various
  nodePackages.vim-language-server
  tree-sitter
]
