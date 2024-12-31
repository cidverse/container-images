# related to: https://raw.githubusercontent.com/NixOS/nixpkgs/dbbc4b1b28a9d2d2043fbf23aefbb86a6b06a25a/pkgs/build-support/docker/default.nix
# docs: https://ryantm.github.io/nixpkgs/builders/images/dockertools/
{ pkgs }:

{
  # buildImage
  buildImage =
    let
      createDirs = pkgs.runCommand "tmp" { } ''
        mkdir $out
        mkdir -m 0770 $out/tmp
        mkdir -m 0770 $out/var
        mkdir -m 0770 -p $out/home/appuser
      '';

      microBasePackages = [
        pkgs.dockerTools.binSh # /bin/sh
        pkgs.dockerTools.usrBinEnv # /usr/bin/env
        pkgs.dockerTools.caCertificates # SSL/TLS certificates
        pkgs.fakeNss # Provide a /etc/passwd and /etc/group with root/nobody
        pkgs.iana-etc # /etc/services and related files
        pkgs.tzdata # Timezone data
        createDirs
      ];
      minimalBasePackages = [
        pkgs.coreutils # Core utilities like ls, cat, etc.
        pkgs.glibc # Standard C library
        pkgs.bashInteractive # Interactive bash shell
      ];

      basePackageSets = {
        "micro" = microBasePackages;
        "minimal" = microBasePackages ++ minimalBasePackages;
      };
      basePackageDefaultCmds = {
        "micro" = [
          "/usr/bin/env"
          "sh"
        ];
        "minimal" = [
          "/usr/bin/env"
          "bash"
        ];
      };
    in
    (
      {
        name,
        version,
        arch ? "amd64",
        rootPackage,
        basePackageSet ? "minimal",
        additionalPackages ? [ ],
        extraCommands ? "",
        maxLayers ? 100,
        compressor ? "none", # "none", "gz","zstd"
        entrypoint ? null,
        volumes ? { },
        env ? [ ],
        ...
      }@args:
      let
        basePackages = basePackageSets.${basePackageSet};
        contents = basePackages ++ [ rootPackage ] ++ additionalPackages;
        defaultCmd = basePackageDefaultCmds.${basePackageSet};
      in
      pkgs.dockerTools.buildLayeredImage {
        name = "quay.io/cidverse/" + name;
        tag = version;
        maxLayers = maxLayers;
        compressor = compressor;

        architecture = arch;
        enableFakechroot = false;

        contents = contents;
        extraCommands =
          extraCommands
          + ''
            chmod -R g=u tmp var home
          '';

        config = {
          Entrypoint = entrypoint;
          Cmd = defaultCmd;

          Env = [
            "HOME=/home/appuser"
            "LC_ALL=C"
            "DISPLAY=:0"
          ] ++ env;
          ExposedPorts = { };
          Volumes = volumes;
          User = "1001";
          WorkingDir = "/home/appuser";

          Maintainer = [
            "Philipp Heuer <git@philippheuer.de>"
          ];
          Labels = {
            "io.github.cidverse.component" = name;
            "io.github.cidverse.component-version" = version;
            "org.opencontainers.image.source" = "https://github.com/cidverse/container-images";
            "org.opencontainers.image.description" = name;
            "org.opencontainers.image.licenses" = "MIT";
          };
        };
      }
    );
}
