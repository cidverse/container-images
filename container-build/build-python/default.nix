{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.python313;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "build-python";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [
      pkgs.python313Packages.pip
      pkgs.python313Packages.pipx
    ];
    maxLayers = 80;
    arch = "amd64";
  };
}
