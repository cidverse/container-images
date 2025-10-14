{
  self,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
in
{
  image-amd64 = containerSupport.buildImage {
    name = "ci-gitlab-docker";
    version = "0.1.0";
    rootPackage = pkgs.docker-client;
    additionalPackages = [
      pkgs.gnugrep # grep
      pkgs.curl # curl
      inputs.nixpkgs-philippheuer.packages.${pkgs.system}.gitlab-sarif-converter # sarif to gitlab code quality conversion
    ];
    maxLayers = 100;
    arch = "amd64";
  };
}
