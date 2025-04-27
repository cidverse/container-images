{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.golangci-lint;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "golangci-lint";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [
      pkgs-unstable.go
    ];
    arch = "amd64";
  };
}
