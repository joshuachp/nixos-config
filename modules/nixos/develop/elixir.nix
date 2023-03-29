{ pkgs
, ...
}: {
  config = {
    environment.systemPackages = import ../../../pkgs/develop/elixir.nix pkgs;
  };
}
