# Configure the way to install packages
{ home-manager ? false
}: (
  pkgs:
  if home-manager then
    { home.packages = pkgs; }
  else
    { environment.systemPackages = pkgs; }
)
