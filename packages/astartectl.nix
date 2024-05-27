{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
}:
let
  version = "23.5.0";
  pname = "astartectl";
in
buildGoModule {
  inherit version pname;
  src = fetchFromGitHub {
    owner = "astarte-platform";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-4NgDVuYEeJI5Arq+/+xdyUOBWdCLALM3EKVLSFimJlI=";
  };
  vendorHash = "sha256-Syod7SUsjiM3cdHPZgjH/3qdsiowa0enyV9DN8k13Ws=";
  # Completion
  nativeBuildInputs = [ installShellFiles ];
  postInstall = ''
    installShellCompletion --cmd ${pname} \
      --bash <($out/bin/${pname} completion bash) \
      --zsh <($out/bin/${pname} completion zsh)
  '';

  meta = {
    description = "Astarte command line client utility";
    homepage = "https://github.com/astarte-platform/astartectl";
    license = with lib.licenses; [ asl20 ];
    maintainer = [ ];
  };
}
