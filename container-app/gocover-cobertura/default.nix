{
  self,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  #rootPackage = pkgs-unstable.gocover-cobertura;
  rootPackage = inputs.nixpkgs-philippheuer.packages.${pkgs.system}.gocover-cobertura;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "gocover-cobertura";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [
      pkgs.go
    ];
    arch = "amd64";
  };
}
