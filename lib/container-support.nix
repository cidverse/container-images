# related to: https://raw.githubusercontent.com/NixOS/nixpkgs/dbbc4b1b28a9d2d2043fbf23aefbb86a6b06a25a/pkgs/build-support/docker/default.nix
# docs: https://ryantm.github.io/nixpkgs/builders/images/dockertools/
# pkgs should be the same package set the image's rootPackage comes from, to avoid shipping two glibc/bash/coreutils closures
{ pkgs }:

let
  lib = pkgs.lib;

  # spdx expression for the oci licenses label, derived from the package metadata
  licenseLabel =
    package:
    let
      licenses = lib.toList (package.meta.license or [ ]);
      toSpdx = l: if builtins.isString l then l else l.spdxId or "LicenseRef-${l.shortName or "unknown"}";
    in
    if licenses == [ ] then "NOASSERTION" else lib.concatStringsSep " AND " (map toSpdx licenses);
in
{
  # buildImage
  buildImage =
    let
      containerCaCertificates =
        let
          baseCacert = pkgs.cacert.override {
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
        in
        # workaround for https://github.com/semgrep/semgrep/issues/11525
        pkgs.symlinkJoin {
          name = "container-ca-certificates";
          paths = [ baseCacert ];
          postBuild = ''
            ln -s ca-bundle.crt $out/etc/ssl/certs/ca-certificates.crt
          '';
        };

      # package sets
      microBasePackages = [
        pkgs.dockerTools.binSh # /bin/sh
        pkgs.dockerTools.usrBinEnv # /usr/bin/env
        containerCaCertificates # SSL/TLS certificates
        pkgs.iana-etc # /etc/services and related files
        pkgs.tzdata # Timezone data
      ];
      minimalBasePackages = [
        pkgs.coreutils # Core utilities like ls, cat, etc.
        pkgs.glibc # Standard C library
        pkgs.glibcLocalesUtf8 # UTF-8 locale data for glibc (used via LOCALE_ARCHIVE)
        pkgs.bash # Bash shell
      ];
      basePackageSets = {
        "micro" = microBasePackages;
        "minimal" = microBasePackages ++ minimalBasePackages;
      };
      basePackageEnv = {
        "micro" = [ ];
        "minimal" = [
          "LOCALE_ARCHIVE=${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive"
        ];
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
        fakeRootCommands ? "",
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
        # /etc/passwd and /etc/group with root/nobody, plus an entry for the image user so passwd lookups (git, ssh, python, ...) work
        nss = pkgs.fakeNss.override {
          extraPasswdLines = lib.optional (user != "0") "appuser:x:${user}:0:appuser:/home/appuser:/bin/sh";
        };
        contents = basePackages ++ [ nss rootPackage ] ++ additionalPackages;
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
        extraCommands = ''
          mkdir -m 0755 -p home var usr/local/bin
          mkdir -m 0775 -p home/appuser
          mkdir -m 1777 -p tmp var/tmp
        ''
        + extraCommands;
        # home is group 0 writable, so arbitrary uids in the root group (e.g. OpenShift) can use it as well
        fakeRootCommands = ''
          chown ${user}:0 home/appuser
        ''
        + fakeRootCommands;
        config = {
          Entrypoint = entrypoint;
          Cmd = if cmd != null then cmd else defaultCmd;

          Env = [
            "HOME=/home/appuser"
            "DISPLAY=:0"
            "LANG=C.UTF-8"
          ]
          ++ basePackageEnv.${basePackageSet}
          ++ env
          ++ (
            if builtins.length extendPath > 0 then
              [
                "PATH=${builtins.concatStringsSep ":" extendPath}:${defaultPath}"
              ]
            else
              [ ]
          );
          ExposedPorts = { };
          Volumes = volumes;
          User = "${user}:0";
          WorkingDir = "/home/appuser";

          Labels = {
            "io.github.cidverse.component" = name;
            "io.github.cidverse.component-version" = version;
            "org.opencontainers.image.title" = name;
            "org.opencontainers.image.version" = version;
            "org.opencontainers.image.authors" = "github.com/cidverse";
            "org.opencontainers.image.source" = "https://github.com/cidverse/container-images";
            "org.opencontainers.image.description" = rootPackage.meta.description or name;
            "org.opencontainers.image.licenses" = licenseLabel rootPackage;
          };
        };
      }
    );
}
