{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.kubernetes-helm;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "helm";
    version = rootPackage.version;
    rootPackage = (pkgs.wrapHelm pkgs-unstable.kubernetes-helm {
      plugins = [
        pkgs-unstable.kubernetes-helmPlugins.helm-git
        pkgs-unstable.kubernetes-helmPlugins.helm-diff
        pkgs-unstable.kubernetes-helmPlugins.helm-unittest
      ];
    });
    additionalPackages = [
      pkgs.git
    ];
    extraCommands = ''
      mkdir -m 777 -p home/appuser/.kube
      mkdir -m 777 -p home/appuser/.config/helm
      mkdir -m 777 -p home/appuser/.local/share/helm
      mkdir -m 777 -p home/appuser/.cache/helm
    '';
    arch = "amd64";
  };
}
