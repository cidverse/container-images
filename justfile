_default:
	@just -l

publish +PKG:
    scripts/publish.sh "{{PKG}}"

publish-force +PKG:
    scripts/publish.sh "{{PKG}}" -f

publish-all:
    # ci images
    #scripts/publish.sh "ci-gitlab" || true
    #scripts/publish.sh "ci-gitlab-docker" || true
    # base images
    #scripts/publish.sh "dotnet-sdk" || true
    #scripts/publish.sh "dotnet-runtime" || true
    #scripts/publish.sh "node-sdk" || true
    #scripts/publish.sh "base-python" || true
    #scripts/publish.sh "base-jdk-11" || true
    #scripts/publish.sh "base-jdk-17" || true
    #scripts/publish.sh "base-jdk-21" || true
    #scripts/publish.sh "base-jdk-25" || true
    #scripts/publish.sh "build-go" || true
    #scripts/publish.sh "build-python" || true
    # tool images
    scripts/publish.sh "ansible" || true
    scripts/publish.sh "ansible-lint" || true
    scripts/publish.sh "appinspector" || true
    scripts/publish.sh "aws" || true
    scripts/publish.sh "buildah" || true
    scripts/publish.sh "codecov-cli" || true
    scripts/publish.sh "cosign" || true
    scripts/publish.sh "cue" || true
    scripts/publish.sh "flake8" || true
    scripts/publish.sh "fossa-cli" || true
    scripts/publish.sh "ggshield" || true
    scripts/publish.sh "gh" || true
    scripts/publish.sh "gitleaks" || true
    scripts/publish.sh "glab" || true
    scripts/publish.sh "gosec" || true
    scripts/publish.sh "golangci-lint" || true
    scripts/publish.sh "grype" || true
    scripts/publish.sh "hadolint" || true
    scripts/publish.sh "helm" || true
    scripts/publish.sh "helmfile" || true
    scripts/publish.sh "hugo" || true
    scripts/publish.sh "jdk" || true
    scripts/publish.sh "kube-state-metrics" || true
    scripts/publish.sh "kubectl" || true
    scripts/publish.sh "kubeseal" || true
    scripts/publish.sh "liquibase" || true
    scripts/publish.sh "maven" || true
    scripts/publish.sh "minio-client" || true
    scripts/publish.sh "mockery" || true
    scripts/publish.sh "graalvm" || true
    scripts/publish.sh "gitlab-sarif-converter" || true
    scripts/publish.sh "normalizeci" || true
    scripts/publish.sh "openshift" || true
    scripts/publish.sh "oras" || true
    scripts/publish.sh "osv-scanner" || true
    scripts/publish.sh "pipenv" || true
    scripts/publish.sh "podman" || true
    scripts/publish.sh "poetry" || true
    scripts/publish.sh "rekor-cli" || true
    scripts/publish.sh "renovate" || true
    scripts/publish.sh "rundeck-cli" || true
    scripts/publish.sh "runpodctl" || true
    scripts/publish.sh "sarifrs" || true
    scripts/publish.sh "scorecard" || true
    scripts/publish.sh "semgrep" || true
    scripts/publish.sh "shellcheck" || true
    scripts/publish.sh "skopeo" || true
    scripts/publish.sh "slsa-verifier" || true
    scripts/publish.sh "sonarscanner-cli" || true
    scripts/publish.sh "syft" || true
    scripts/publish.sh "twitch-cli" || true
    scripts/publish.sh "upx" || true
    scripts/publish.sh "uv" || true
    scripts/publish.sh "wrangler" || true
    scripts/publish.sh "zizmor" || true
    scripts/publish.sh "opencode" || true
    # app images
    scripts/publish.sh "photon" || true
