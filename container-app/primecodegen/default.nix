{
  self,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = inputs.nixpkgs-philippheuer.packages.${pkgs.system}.primecodegen;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "primecodegen";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [
        inputs.nixpkgs-philippheuer.packages.${pkgs.system}.primecodegen
        inputs.nixpkgs-philippheuer.packages.${pkgs.system}.oasdiff
        pkgs.openapi-generator-cli
        pkgs.redocly
        pkgs.google-java-format
    ];
    arch = "amd64";
    volumes = {
      "/tmp" = {};
    };
  };
}
