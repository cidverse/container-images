{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.helmfile;
in
{
  image-amd64 = containerSupport.buildImage {
    name = "helmfile";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [
      pkgs.git
      (pkgs.wrapHelm pkgs-unstable.kubernetes-helm {
        plugins = [
          pkgs-unstable.kubernetes-helmPlugins.helm-git
          pkgs-unstable.kubernetes-helmPlugins.helm-diff
          pkgs-unstable.kubernetes-helmPlugins.helm-unittest
        ];
      })
    ];
    extraCommands = ''
      mkdir -m 0770 -p home/appuser/.kube
      mkdir -m 0770 -p home/appuser/.config/helm
      mkdir -m 0770 -p home/appuser/.local/share/helm
      mkdir -m 0770 -p home/appuser/.cache/helm
    '';
    arch = "amd64";
  };
}
