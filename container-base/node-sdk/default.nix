{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.nodejs_23;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "node-sdk";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [
      pkgs-unstable.yarn-berry
    ];
    maxLayers = 100;
    arch = "amd64";
    env = [
      "NPM_CONFIG_USER_AGENT=none" # set user agent to nixpkgs
      "NPM_CONFIG_AUDIT=false" # disable automatic npm audit
      "NPM_CONFIG_UPDATE_NOTIFIER=false" # disable npm update notifier

      "YARN_ENABLE_TELEMETRY=0" # disable yarn telemetry

      "VITE_DISABLE_TELEMETRY=true" # disable vite telemetry
      "NEXT_TELEMETRY_DISABLED=1" # disable next.js telemetry
      "NG_CLI_ANALYTICS=false" # disable angular cli telemetry
    ];
  };
}
