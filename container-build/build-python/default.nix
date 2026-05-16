{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.python314;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "build-python";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [
      pkgs-unstable.python314Packages.pip
      pkgs-unstable.python314Packages.pipx
    ];
    maxLayers = 80;
    arch = "amd64";
  };
}
