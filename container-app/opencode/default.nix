{
  self,
  pkgs,
  pkgs-unstable,
  pkgs-master,
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
      # runtime
      pkgs.jdk25
      pkgs.nodejs_26
      pkgs.python315
      pkgs.rustc
      pkgs.cargo

      # nix
      pkgs.nix

      # lsp
      pkgs-unstable.gopls # go
      pkgs-unstable.nixd # nix
      pkgs-unstable.jdt-language-server # java
      pkgs.yaml-language-server # yaml
      pkgs.bash-language-server # bash

      # formatters
      pkgs-unstable.nixfmt
      pkgs-unstable.shfmt
      pkgs-unstable.nufmt
      pkgs-unstable.google-java-format
      pkgs-unstable.ktfmt
      pkgs-unstable.rustfmt

      # vcs
      pkgs.git
      pkgs-unstable.pre-commit

      # lint
      pkgs-unstable.pylint
      pkgs.ansible-lint
      pkgs.shellcheck

      # tools
      pkgs.curl
      pkgs.ripgrep
      pkgs-unstable.ast-grep
      pkgs.fd
      pkgs.jq
      pkgs.yq
      pkgs.fzf
      pkgs.gnused

      # tool runners
      pkgs.gnumake
      pkgs.just
    ];
    extraCommands = ''
      mkdir -m 0770 -p home/appuser
    '';
    arch = "amd64";
  };
}
