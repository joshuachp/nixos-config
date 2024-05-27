{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
let
  pname = "committed";
  version = "1.0.20";
  repo = fetchFromGitHub {
    owner = "crate-ci";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HqZYxV2YjnK7Q3A7B6yVFXME0oc3DZ4RfMkDGa2IQxA=";
  };
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = repo;

  cargoLock = {
    lockFile = repo + "/Cargo.lock";
  };

  meta = {
    description = "Nitpicking commit history since beabf39";
    homepage = "https://github.com/crate-ci/committed";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainer = [ ];
  };
}
