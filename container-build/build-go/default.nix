{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.go;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "build-go";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [ ];
    maxLayers = 80;
    arch = "amd64";
  };
}
