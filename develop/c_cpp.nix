{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    gcc
    bintools

    clang
    clang-analyzer
    clang-tools
    lld

    cmake
    ninja
  ];
}
