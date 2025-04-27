{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.uv;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "uv";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [ ];
    arch = "amd64";
  };
}
