{ pkgs
, ...
}: {
  config = {
    environment.systemPackages = import ../../../pkgs/develop/shell.nix pkgs;
  };
}
