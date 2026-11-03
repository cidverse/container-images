{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.gotestsum;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "gotestsum";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [
      pkgs-unstable.go
    ];
    arch = "amd64";
  };
}
