{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.dotnet-runtime_9;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "dotnet-runtime";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [ ];
    maxLayers = 80;
    arch = "amd64";
    env = [
      "DOTNET_CLI_TELEMETRY_OPTOUT=true" # Disable sending .NET CLI telemetry to Microsoft
      "DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true" # Disable the .NET first time experience to skip caching NuGet packages and speed up the build
      "DOTNET_NOLOGO=true" # Disable the .NET logo in the console output
    ];
  };
}
