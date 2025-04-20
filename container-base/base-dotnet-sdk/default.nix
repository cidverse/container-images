{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.dotnet-sdk_9;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "base-dotnet-sdk";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [ ];
    maxLayers = 80;
    arch = "amd64";
  };
}
