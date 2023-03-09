{ config
, pkgs
, ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      elixir
      elixir_ls
    ];
  };
}
