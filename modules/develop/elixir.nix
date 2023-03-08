{ config
, pkgs
, installPkgs
, ...
}: {
  config = installPkgs (with pkgs; [
    elixir
    elixir_ls
  ]);
}
