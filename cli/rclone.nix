{ pkgs, lib, ... }: {
  nixpkgs.overlays = [
    (self: super: {
      rclone = super.rclone.override rec {
        buildGoModule = args:
          super.buildGoModule.override { } (args // {
            version = "1.58.0";
            src = super.fetchFromGitHub {
              owner = "rclone";
              repo = "rclone";
              rev = "847868b4baf57d77e87d0362962397ce311dba57";
              sha256 = "sha256-WMTliCk0GZai5aUWgInpKwLa28fB8XZGgX8IRQMv29g=";
            };

            vendorSha256 =
              "sha256-mgupx5SNQ3wUkQCeTVnw3wwdSCrTcwLYxcX6tlqXTyQ=";
          });
      };
    })
  ];
}
