{
  self,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = inputs.nixpkgs-philippheuer.packages.${pkgs.system}.normalizeci;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "normalizeci";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [ ];
    arch = "amd64";
  };
}
