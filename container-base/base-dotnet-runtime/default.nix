{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.dotnet-runtime_9;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "base-dotnet-runtime";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [ ];
    maxLayers = 80;
    arch = "amd64";
  };
}
