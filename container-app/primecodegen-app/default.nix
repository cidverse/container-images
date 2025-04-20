{
  self,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = inputs.nixpkgs-philippheuer.packages.${pkgs.system}.primecodegen-app;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "primecodegen-app";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [
        inputs.nixpkgs-philippheuer.packages.${pkgs.system}.primecodegen
        pkgs.openapi-generator-cli
        pkgs.redocly
        pkgs.google-java-format
    ];
    arch = "amd64";
  };
}
