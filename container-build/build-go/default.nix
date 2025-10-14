{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.go_1_25;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "build-go";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [
      pkgs.gcc
      pkgs.pkg-config
    ];
    maxLayers = 100;
    arch = "amd64";
  };
}
