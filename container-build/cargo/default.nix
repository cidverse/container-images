{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.cargo;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "cargo";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [
      pkgs-unstable.gcc
      pkgs-unstable.rustc
      pkgs-unstable.cargo-nextest
    ];
    arch = "amd64";
  };
}
