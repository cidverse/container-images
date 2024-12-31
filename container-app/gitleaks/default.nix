{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.gitleaks;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "gitleaks";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [ pkgs.git ];
    arch = "amd64";
  };
}
