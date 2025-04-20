{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.ansible;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "ansible";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [ pkgs.sshpass ];
    arch = "amd64";
  };
}
