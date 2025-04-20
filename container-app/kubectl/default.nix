{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.kubectl;

  # entrypoint, kubeconfig can be passed as env var
  entrypoint = pkgs.writeScriptBin "kubectl-entrypoint" ''
    #!/usr/bin/env sh
    set -e

    # overwrite kubectl config file (useful for ci/cd)
    if [ -n "$KUBECONFIG_CONTENT" ]; then
        echo $KUBECONFIG_CONTENT | base64 --decode > /home/appuser/.kube/config
    fi

    exec "$@"
  '';
in
{
  image-amd64 = containerSupport.buildImage {
    name = "kubectl";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [ entrypoint ];
    extraCommands = ''
      mkdir -m 0770 -p home/appuser/.kube
    '';
    arch = "amd64";
    entrypoint = [ "/bin/kubectl-entrypoint" ];
  };
}
