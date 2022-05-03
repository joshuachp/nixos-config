{_, ...}: {
  nix.gc = {
    automatic = true;
    dates = "weekly";
  };
}
