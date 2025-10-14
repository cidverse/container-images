{
  self,
  pkgs,
  pkgs-unstable,
  pkgs-master,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs-unstable.semgrep;

  gitConfig = pkgs.writeTextFile {
    name = "gitconfig";
    destination = "/etc/gitconfig";
    text = ''
      [safe]
          directory = *
    '';
  };
in
{
  image-amd64 = containerSupport.buildImage {
    name = "semgrep";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [
      pkgs.git
      gitConfig
    ];
    arch = "amd64";
    extraEnv = {
      GIT_CONFIG_SYSTEM = "/etc/gitconfig";
    };
  };
}
