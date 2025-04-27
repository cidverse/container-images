{
  pkgs ? import <nixpkgs> { },
  pkgs-unstable ? import <nixpkgs> { },
  pkgs-master ? import <nixpkgs> { },
  pkgs-ph ? null,
  inputs ? null,
  self ? null,
  ...
}:

let
  commonArgs = {
    inherit
      pkgs
      pkgs-unstable
      pkgs-master
      pkgs-ph
      inputs
      self
      ;
  };
in
{
  # base packages
  base-dotnet-sdk = pkgs.callPackage ./container-base/base-dotnet-sdk commonArgs;
  base-dotnet-runtime = pkgs.callPackage ./container-base/base-dotnet-runtime commonArgs;
  base-python = pkgs.callPackage ./container-base/base-python commonArgs;
  base-jdk-11 = pkgs.callPackage ./container-base/base-jdk-11 commonArgs;
  base-jdk-17 = pkgs.callPackage ./container-base/base-jdk-17 commonArgs;
  base-jdk-21 = pkgs.callPackage ./container-base/base-jdk-21 commonArgs;

  # build images
  build-go = pkgs.callPackage ./container-build/build-go commonArgs;
  build-python = pkgs.callPackage ./container-build/build-python commonArgs;

  # app images
  ansible = pkgs.callPackage ./container-app/ansible commonArgs;
  ansible-lint = pkgs.callPackage ./container-app/ansible-lint commonArgs;
  appinspector = pkgs.callPackage ./container-app/appinspector commonArgs;
  aws = pkgs.callPackage ./container-app/aws commonArgs;
  buildah = pkgs.callPackage ./container-app/buildah commonArgs;
  codecov-cli = pkgs.callPackage ./container-app/codecov-cli commonArgs;
  cosign = pkgs.callPackage ./container-app/cosign commonArgs;
  cue = pkgs.callPackage ./container-app/cue commonArgs;
  flake8 = pkgs.callPackage ./container-app/flake8 commonArgs;
  fossa-cli = pkgs.callPackage ./container-app/fossa-cli commonArgs;
  ggshield = pkgs.callPackage ./container-app/ggshield commonArgs;
  gh = pkgs.callPackage ./container-app/gh commonArgs;
  gitleaks = pkgs.callPackage ./container-app/gitleaks commonArgs;
  glab = pkgs.callPackage ./container-app/glab commonArgs;
  go-junit-report = pkgs.callPackage ./container-app/go-junit-report commonArgs;
  gocover-cobertura = pkgs.callPackage ./container-app/gocover-cobertura commonArgs;
  gosec = pkgs.callPackage ./container-app/gosec commonArgs;
  grype = pkgs.callPackage ./container-app/grype commonArgs;
  hadolint = pkgs.callPackage ./container-app/hadolint commonArgs;
  helm = pkgs.callPackage ./container-app/helm commonArgs;
  helmfile = pkgs.callPackage ./container-app/helmfile commonArgs;
  hugo = pkgs.callPackage ./container-app/hugo commonArgs;
  jdk = pkgs.callPackage ./container-app/jdk commonArgs;
  kubectl = pkgs.callPackage ./container-app/kubectl commonArgs;
  kubeseal = pkgs.callPackage ./container-app/kubeseal commonArgs;
  liquibase = pkgs.callPackage ./container-app/liquibase commonArgs;
  maven = pkgs.callPackage ./container-app/maven commonArgs;
  minio-client = pkgs.callPackage ./container-app/minio-client commonArgs;
  mockery = pkgs.callPackage ./container-app/mockery commonArgs;
  graalvm = pkgs.callPackage ./container-app/graalvm commonArgs;
  gitlab-sarif-converter = pkgs.callPackage ./container-app/gitlab-sarif-converter commonArgs;
  normalizeci = pkgs.callPackage ./container-app/normalizeci commonArgs;
  openshift = pkgs.callPackage ./container-app/openshift commonArgs;
  oras = pkgs.callPackage ./container-app/oras commonArgs;
  osv-scanner = pkgs.callPackage ./container-app/osv-scanner commonArgs;
  pipenv = pkgs.callPackage ./container-app/pipenv commonArgs;
  podman = pkgs.callPackage ./container-app/podman commonArgs;
  poetry = pkgs.callPackage ./container-app/poetry commonArgs;
  rekor-cli = pkgs.callPackage ./container-app/rekor-cli commonArgs;
  renovate = pkgs.callPackage ./container-app/renovate commonArgs;
  rundeck-cli = pkgs.callPackage ./container-app/rundeck-cli commonArgs;
  runpodctl = pkgs.callPackage ./container-app/runpodctl commonArgs;
  sarifrs = pkgs.callPackage ./container-app/sarifrs commonArgs;
  scorecard = pkgs.callPackage ./container-app/scorecard commonArgs;
  semgrep = pkgs.callPackage ./container-app/semgrep commonArgs;
  shellcheck = pkgs.callPackage ./container-app/shellcheck commonArgs;
  skopeo = pkgs.callPackage ./container-app/skopeo commonArgs;
  slsa-verifier = pkgs.callPackage ./container-app/slsa-verifier commonArgs;
  sonarscanner-cli = pkgs.callPackage ./container-app/sonarscanner-cli commonArgs;
  syft = pkgs.callPackage ./container-app/syft commonArgs;
  trivy = pkgs.callPackage ./container-app/trivy commonArgs;
  twitch-cli = pkgs.callPackage ./container-app/twitch-cli commonArgs;
  upx = pkgs.callPackage ./container-app/upx commonArgs;
  uv = pkgs.callPackage ./container-app/uv commonArgs;
  wrangler = pkgs.callPackage ./container-app/wrangler commonArgs;
  zizmor = pkgs.callPackage ./container-app/zizmor commonArgs;
  primecodegen-app = pkgs.callPackage ./container-app/primecodegen-app commonArgs;
  qodana = pkgs.callPackage ./container-app/qodana commonArgs;
}
