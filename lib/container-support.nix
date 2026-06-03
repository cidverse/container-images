# related to: https://raw.githubusercontent.com/NixOS/nixpkgs/dbbc4b1b28a9d2d2043fbf23aefbb86a6b06a25a/pkgs/build-support/docker/default.nix
# docs: https://ryantm.github.io/nixpkgs/builders/images/dockertools/
{ pkgs }:

{
  # buildImage
  buildImage =
    let
      # certificates
      containerCaCertificates = pkgs.cacert.override {
        extraCertificateFiles = [
          #(pkgs.writeText "my-internal-root-ca.crt" ''
          #  -----BEGIN CERTIFICATE-----
          #  MIIFljCCA36gAwIBAgINAgO7buGoNi8aFJgvkDANBgkqhkiG9w0BAQsFADBHMQsw
          #  ... your certificate content here ...
          #  -----END CERTIFICATE-----
          #'')
          # Alternatively, point to a local repository file:
          # ./certs/another-corporate-ca.crt
        ];
      };

      # package sets
      microBasePackages = [
        pkgs.dockerTools.binSh # /bin/sh
        pkgs.dockerTools.usrBinEnv # /usr/bin/env
        containerCaCertificates # SSL/TLS certificates
        pkgs.fakeNss # Provide a /etc/passwd and /etc/group with root/nobody
        pkgs.iana-etc # /etc/services and related files
        pkgs.tzdata # Timezone data
      ];
      minimalBasePackages = [
        pkgs.coreutils # Core utilities like ls, cat, etc.
        pkgs.glibc # Standard C library
        pkgs.glibcLocales # Locale data for glibc
        pkgs.bash # Bash shell
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
        maxLayers ? 120,
        compressor ? "zstd", # "none", "gz","zstd"
        user ? "1001",
        entrypoint ? null,
        cmd ? null,
        volumes ? { },
        env ? [ ],
        extendPath ? [ ],
        ciMode ? false,
        ...
      }@args:
      let
        basePackages = basePackageSets.${basePackageSet};
        contents = basePackages ++ [ rootPackage ] ++ additionalPackages;
        defaultCmd = basePackageDefaultCmds.${basePackageSet};
        defaultPath = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
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
          ''
            mkdir -m 1777 -p home/appuser tmp var home usr/local/bin
          '' +
          extraCommands;
        config = {
          Entrypoint = entrypoint;
          Cmd = if cmd != null then cmd else defaultCmd;

          Env = [
            "HOME=/home/appuser"
            "DISPLAY=:0"
          ] ++ env ++ (if builtins.length extendPath > 0 then [
            "PATH=${builtins.concatStringsSep ":" extendPath}:${defaultPath}"
          ] else []);
          ExposedPorts = { };
          Volumes = volumes;
          User = "${user}:0";
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
