{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.jdk11;
  rootPackageVersion = builtins.replaceStrings ["+"] ["-patch."] rootPackage.version;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "base-jdk11";
    version = rootPackageVersion;
    rootPackage = rootPackage;
    additionalPackages = [ ];
    maxLayers = 80;
    arch = "amd64";
  };
}
