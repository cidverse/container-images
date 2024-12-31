{
  self,
  pkgs,
  pkgs-unstable,
  pkgs-ph,
  inputs,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = inputs.nixpkgs-philippheuer.packages.${pkgs.system}.rundeck-cli;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "rundeck-cli";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [ pkgs.jdk21 ];
    env = [
      "JAVA_HOME=${pkgs.jdk21}/lib/openjdk"
    ];
    arch = "amd64";
  };
}
