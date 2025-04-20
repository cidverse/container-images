{
  self,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = inputs.nixpkgs-philippheuer.packages.${pkgs.system}.qodana;

  qodanaDirs = pkgs.runCommand "tmp" { } ''
    mkdir $out
    mkdir -m 0770 -p $out/home/appuser/.cache/JetBrains/Qodana
  '';
in
{
  image-amd64 = containerSupport.buildImage {
    name = "qodana";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [
      pkgs.gnutar
      pkgs.gzip
      pkgs.libzip
      qodanaDirs
    ];
    arch = "amd64";
  };
}
