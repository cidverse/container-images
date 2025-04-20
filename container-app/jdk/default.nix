{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.jdk21_headless;
  rootPackageVersion = builtins.replaceStrings ["+"] ["-patch."] rootPackage.version;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "jdk";
    version = rootPackageVersion;
    rootPackage = rootPackage;
    additionalPackages = [];
    arch = "amd64";
    extendPath = [
      "${rootPackage}/bin"
    ];
  };
}
