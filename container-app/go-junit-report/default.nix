{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.go-junit-report;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "go-junit-report";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [];
    arch = "amd64";
  };
}
