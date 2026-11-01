{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.betterleaks;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "betterleaks";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [ pkgs.git ];
    arch = "amd64";
  };
}
