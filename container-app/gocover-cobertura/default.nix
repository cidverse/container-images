{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.gocover-cobertura;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "gocover-cobertura";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [];
    arch = "amd64";
  };
}
