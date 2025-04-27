{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.maven;
  rootPackageVersion = rootPackage.version;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "maven";
    version = rootPackageVersion;
    rootPackage = rootPackage;
    additionalPackages = [
      pkgs-unstable.jdk21_headless
    ];
    arch = "amd64";
    extendPath = [
      "${pkgs-unstable.jdk21_headless}/bin"
    ];
  };
}
