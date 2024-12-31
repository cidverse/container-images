{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.graalvm-ce;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "graalvm";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [ ];
    arch = "amd64";
  };
}
