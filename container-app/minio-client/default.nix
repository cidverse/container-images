{
  self,
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.minio-client;
  formattedVersion = lib.concatStringsSep "." (lib.splitString "-" (builtins.head (lib.splitString "T" rootPackage.version)));
in
{
  image-amd64 = containerSupport.buildImage {
    name = "minio-client";
    version = formattedVersion;
    rootPackage = rootPackage;
    additionalPackages = [ ];
    arch = "amd64";
  };
}
