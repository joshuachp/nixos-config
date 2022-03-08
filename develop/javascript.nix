{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ nodePackages.prettier ];
}
