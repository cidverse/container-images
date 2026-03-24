{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.opencode;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "opencode";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [

    ];
    extraCommands = ''
      mkdir -m 0770 -p home/appuser
    '';
    arch = "amd64";
  };
}
