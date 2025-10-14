{
  self,
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
in
{
  image-amd64 = containerSupport.buildImage {
    name = "ci-gitlab";
    version = "0.1.0";
    rootPackage = pkgs-unstable.podman;
    additionalPackages = [
      pkgs.gnugrep # grep
      pkgs.curl # curl
      inputs.nixpkgs-philippheuer.packages.${pkgs.system}.gitlab-sarif-converter # sarif to gitlab code quality conversion
    ];
    arch = "amd64";
    maxLayers = 100;
    user = "0";
    extraCommands = ''
      mkdir -m 0770 -p var/tmp
      mkdir -m 0770 -p var/lib/shared
      mkdir -m 0770 -p usr/lib/containers/storage
      mkdir -m 0770 -p etc/containers

      cat > etc/containers/policy.json <<EOF
      {
          "default": [
              {
                  "type": "insecureAcceptAnything"
              }
          ],
          "transports": {
              "docker-daemon": {
                  "": [{"type":"insecureAcceptAnything"}]
              }
          }
      }
      EOF

      cat > etc/containers/storage.conf <<EOF
      [storage]
      driver = "overlay"
      runroot = "/run/containers/storage"
      graphroot = "/var/lib/containers/storage"

      [storage.options]
      additionalimagestores = [
        "/var/lib/shared",
        "/usr/lib/containers/storage",
      ]
      pull_options = {enable_partial_images = "true", use_hard_links = "false", ostree_repos=""}

      [storage.options.overlay]
      mount_program = "/bin/fuse-overlayfs"
      mountopt = "nodev,fsync=0"
      EOF

      cat > etc/containers/registries.conf <<EOF
      # For more information on this configuration file, see containers-registries.conf(5).
      unqualified-search-registries = []
      short-name-mode = "enforcing"
      EOF
    '';
    env = [
      "PODMAN_IGNORE_CGROUPSV1_WARNING=true"
      "BUILDAH_ISOLATION=chroot"
      "_CONTAINERS_USERNS_CONFIGURED=done"
      "container=oci"
      "PODMAN_USERNS=host"
    ];
  };
}
