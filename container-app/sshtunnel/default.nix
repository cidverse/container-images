{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };

  entrypointScript = pkgs.writeScriptBin "sshtunnel-entrypoint" ''
    #!/usr/bin/env bash
    set -euo pipefail

    log() { echo "[$(date -Iseconds)] $*"; }

    #
    # SSH Tunnel Container
    #
    # Connection:
    #   SSH_HOST=user@server              - SSH user and server (preferred)
    #   SSH_USER + SSH_SERVER             - Legacy fallback
    #
    # Tunnels (choose one):
    #   TUNNELS="lp:thost:tport lp:thost:tport ..."   - Multiple tunnels (space-separated)
    #     where lp=listen_port, thost=target_host, tport=target_port
    #   TARGET_HOST + TARGET_PORT + LISTEN_PORT       - Single tunnel (legacy fallback)
    #
    # Optional env vars:
    #   TUNNEL_MODE                  - Forward direction: local (default) or remote
    #   SSH_PORT                     - SSH server port (default: 22)
    #   SSH_PRIVATE_KEY_B64          - Base64-encoded private key (single line)
    #   SSH_PRIVATE_KEY              - Private key content (multiline, takes precedence over B64)
    #   SSH_KNOWN_HOSTS              - known_hosts content (multiline)
    #   STRICT_HOST_KEY_CHECKING     - SSH StrictHostKeyChecking (default: accept-new)
    #   SERVER_ALIVE_INTERVAL        - Keepalive interval in seconds (default: 30)
    #   SERVER_ALIVE_COUNT_MAX       - Keepalive count max (default: 3)
    #   EXTRA_SSH_ARGS               - Extra arguments passed to ssh
    #
    # Command Restrictions (recommended for ~/.ssh/authorized_keys on the server):
    #   Force the SSH key to only allow port forwarding and explicitly disable
    #   interactive shell access. Example authorized_keys entry:
    #     restrict,port-forwarding,permitopen="localhost:TARGET_PORT",no-pty,no-X11-forwarding,no-agent-forwarding ssh-ed25519 AAAA...
    #   For multiple tunnels, add one permitopen per target:port pair:
    #     restrict,port-forwarding,permitopen="localhost:5432",permitopen="localhost:8080",no-pty,no-X11-forwarding,no-agent-forwarding ...
    #

    # --- Connection ---
    if [[ -n "''${SSH_HOST:-}" ]]; then
      SSH_DEST="''${SSH_HOST}"
    else
      : "''${SSH_USER:?Missing SSH_HOST or SSH_USER}"
      : "''${SSH_SERVER:?Missing SSH_HOST or SSH_SERVER}"
      SSH_DEST="''${SSH_USER}@''${SSH_SERVER}"
    fi

    # --- Tunnels ---
    TUNNEL_MODE="''${TUNNEL_MODE:-local}"
    FORWARD_FLAG="-L"
    if [[ "''${TUNNEL_MODE}" == "remote" ]]; then
      FORWARD_FLAG="-R"
    fi

    SSH_OPTS=(
      -N
      -p "''${SSH_PORT:-22}"
      -o "ExitOnForwardFailure=yes"
      -o "ServerAliveInterval=''${SERVER_ALIVE_INTERVAL:-30}"
      -o "ServerAliveCountMax=''${SERVER_ALIVE_COUNT_MAX:-3}"
      -o "StrictHostKeyChecking=''${STRICT_HOST_KEY_CHECKING:-accept-new}"
    )

    if [[ -n "''${TUNNELS:-}" ]]; then
      IFS=' ' read -ra TUNNEL_LIST <<< "''${TUNNELS}"
      for tunnel in "''${TUNNEL_LIST[@]}"; do
        IFS=':' read -r LP THOST TPORT <<< "''${tunnel}"
        if [[ -z "''${LP:-}" || -z "''${THOST:-}" || -z "''${TPORT:-}" ]]; then
          log "WARN: skipping malformed tunnel entry: ''${tunnel}"
          continue
        fi
        SSH_OPTS+=(''${FORWARD_FLAG} "0.0.0.0:''${LP}:''${THOST}:''${TPORT}")
        log "  tunnel: 0.0.0.0:''${LP} -> ''${THOST}:''${TPORT}"
      done
    else
      : "''${TARGET_HOST:?Missing TUNNELS or TARGET_HOST}"
      : "''${TARGET_PORT:?Missing TUNNELS or TARGET_PORT}"
      SSH_OPTS+=(''${FORWARD_FLAG} "0.0.0.0:''${LISTEN_PORT:-8080}:''${TARGET_HOST}:''${TARGET_PORT}")
      log "  tunnel: 0.0.0.0:''${LISTEN_PORT:-8080} -> ''${TARGET_HOST}:''${TARGET_PORT}"
    fi

    # --- SSH key material ---
    SSH_KEY_PATH="''${SSH_KEY_PATH:-/etc/ssh-secrets/id_rsa}"
    KNOWN_HOSTS_PATH="''${KNOWN_HOSTS_PATH:-/etc/ssh-secrets/known_hosts}"
    WORK_DIR="''${WORK_DIR:-/tmp/ssh-material}"

    if [[ -n "''${SSH_PRIVATE_KEY:-}" ]]; then
      mkdir -p "''${WORK_DIR}"
      chmod 700 "''${WORK_DIR}"
      SSH_KEY_PATH="''${WORK_DIR}/id_rsa"
      printf '%s\n' "''${SSH_PRIVATE_KEY}" > "''${SSH_KEY_PATH}"
      log "Using private key from SSH_PRIVATE_KEY"
    elif [[ -n "''${SSH_PRIVATE_KEY_B64:-}" ]]; then
      mkdir -p "''${WORK_DIR}"
      chmod 700 "''${WORK_DIR}"
      SSH_KEY_PATH="''${WORK_DIR}/id_rsa"
      echo "''${SSH_PRIVATE_KEY_B64}" | base64 -d > "''${SSH_KEY_PATH}"
      log "Using private key from SSH_PRIVATE_KEY_B64"
    fi

    if [[ -n "''${SSH_KNOWN_HOSTS:-}" ]]; then
      mkdir -p "''${WORK_DIR}"
      KNOWN_HOSTS_PATH="''${WORK_DIR}/known_hosts"
      printf '%s\n' "''${SSH_KNOWN_HOSTS}" > "''${KNOWN_HOSTS_PATH}"
      log "Using known_hosts from SSH_KNOWN_HOSTS"
    fi

    if [[ ! -f "''${SSH_KEY_PATH}" ]]; then
      log "ERROR: SSH key not found at ''${SSH_KEY_PATH} - set SSH_PRIVATE_KEY or SSH_PRIVATE_KEY_B64"
      exit 1
    fi

    chmod 0400 "''${SSH_KEY_PATH}"

    if [[ -f "''${KNOWN_HOSTS_PATH}" ]]; then
      SSH_OPTS+=(-o "UserKnownHostsFile=''${KNOWN_HOSTS_PATH}")
    else
      log "WARN: known_hosts not found at ''${KNOWN_HOSTS_PATH}"
    fi

    SSH_OPTS+=(-i "''${SSH_KEY_PATH}")

    log "Starting SSH tunnel(s) via ''${SSH_DEST}:''${SSH_PORT:-22}"

    # shellcheck disable=SC2086
    exec ssh "''${SSH_OPTS[@]}" ''${EXTRA_SSH_ARGS:-} "''${SSH_DEST}"
  '';
in
{
  image-amd64 = containerSupport.buildImage {
    name = "sshtunnel";
    version = "0.1.0";
    rootPackage = pkgs.openssh;
    additionalPackages = [
      entrypointScript
    ];
    entrypoint = [ "/bin/sshtunnel-entrypoint" ];
    arch = "amd64";
  };
}
