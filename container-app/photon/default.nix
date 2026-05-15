{
  self,
  pkgs,
  pkgs-unstable,
  ...
}:

let
  containerSupport = import (self + "/lib/container-support.nix") { inherit pkgs; };
  rootPackage = pkgs.callPackage (self + "/packages/photon") {
    jdk21_headless = pkgs-unstable.jdk21_headless;
  };

  photonEntrypoint = pkgs.writeScriptBin "photon-entrypoint" ''
    #!/usr/bin/env sh
    set -eu

    if [ "''${DOWNLOAD_ON_START:-false}" = "true" ]; then
      /bin/photon-downloader
    fi

    PHOTON_DATA_DIR="''${PHOTON_DATA_DIR:-/data}"
    PHOTON_LISTEN_IP="''${PHOTON_LISTEN_IP:-0.0.0.0}"
    RESOLVED_DATA_DIR="$PHOTON_DATA_DIR"
    echo "Using Photon 1.x base data dir: $RESOLVED_DATA_DIR"

    set -- serve -listen-ip "$PHOTON_LISTEN_IP" -data-dir "$RESOLVED_DATA_DIR" -metrics-enable prometheus

    if [ -n "''${PHOTON_PARAMS:-}" ]; then
      # shellcheck disable=SC2086
      set -- "$@" ''${PHOTON_PARAMS}
    fi

    exec photon "$@"
  '';

  photonDownloader = pkgs.writeScriptBin "photon-downloader" ''
    #!/usr/bin/env sh
    set -eu

    bool_true() {
      case "''${1:-}" in
        1|true|TRUE|yes|YES|on|ON) return 0 ;;
        *) return 1 ;;
      esac
    }

    bytes_to_mib() {
      echo "$(( $1 / 1024 / 1024 ))"
    }

    bytes_to_gib() {
      echo "$(( $1 / 1024 / 1024 / 1024 ))"
    }

    download_with_resume_and_progress() {
      url="$1"
      output_file="$2"
      progress_interval="$3"

      mkdir -p "$(dirname "$output_file")"

      if [ -f "$output_file" ]; then
        echo "Removing previous archive before fresh download"
        rm -f "$output_file"
      fi

      curl -fL --retry 5 --retry-all-errors --connect-timeout 20 --max-time 0 -o "$output_file" "$url" &
      curl_pid="$!"

      while kill -0 "$curl_pid" 2>/dev/null; do
        current_size=0
        if [ -f "$output_file" ]; then
          current_size="$(wc -c < "$output_file" | tr -d ' ')"
        fi

        echo "Download progress: $(bytes_to_gib "$current_size") GiB ($(bytes_to_mib "$current_size") MiB)"
        sleep "$progress_interval"
      done

      wait "$curl_pid"
    }

    activate_release() {
      release_dir="$1"
      release_db_dir="$release_dir/photon_data"

      if [ ! -d "$release_db_dir" ]; then
        echo "Cannot activate release, missing: $release_db_dir"
        exit 1
      fi

      if [ -e "$ACTIVE_DB_LINK" ] && [ ! -L "$ACTIVE_DB_LINK" ]; then
        LEGACY_RELEASE_DIR="$RELEASES_ROOT/legacy-migrated"
        if [ ! -d "$LEGACY_RELEASE_DIR" ]; then
          echo "Migrating existing non-symlink $ACTIVE_DB_LINK to $LEGACY_RELEASE_DIR"
          mkdir -p "$(dirname "$LEGACY_RELEASE_DIR")"
          mv "$ACTIVE_DB_LINK" "$LEGACY_RELEASE_DIR"
        else
          echo "Removing existing non-symlink $ACTIVE_DB_LINK"
          rm -rf "$ACTIVE_DB_LINK"
        fi
      fi

      TMP_LINK="$DATA_DIR/.photon_data.next"
      ln -sfn "$release_db_dir" "$TMP_LINK"
      mv -Tf "$TMP_LINK" "$ACTIVE_DB_LINK"

      printf '%s\n' "$release_dir" > "$ACTIVE_DATA_FILE"
      printf '%s\n' "$FILE_URL" > "$INDEX_SOURCE_FILE"
      echo "Activated Photon DB release: $release_dir"
    }

    DATA_DIR="''${PHOTON_DATA_DIR:-/data}"
    DATA_TMP_DIR="''${DATA_TMP_DIR:-/tmp/photon-download}"
    BASE_URL="''${BASE_URL:-https://download1.graphhopper.com/public}"
    DB_DUMP_VARIANT="''${DB_DUMP_VARIANT:-}"
    PROGRESS_INTERVAL_SECONDS="''${PROGRESS_INTERVAL_SECONDS:-10}"
    FILE_URL="''${FILE_URL:-}"
    MD5_URL="''${MD5_URL:-}"
    DB_DUMP_FORCE_DOWNLOAD="''${DB_DUMP_FORCE_DOWNLOAD:-false}"
    SKIP_MD5_CHECK="''${SKIP_MD5_CHECK:-false}"

    ACTIVE_DB_LINK="$DATA_DIR/photon_data"
    LEGACY_V1_ES_DIR="$DATA_DIR/photon_data/elasticsearch"
    ACTIVE_DATA_FILE="$DATA_DIR/.photon_active_data_dir"
    INDEX_SOURCE_FILE="$DATA_DIR/.photon_index_source"
    RELEASES_ROOT="$DATA_DIR/releases/photon"

    mkdir -p "$DATA_DIR" "$DATA_TMP_DIR"

    if [ -z "$FILE_URL" ]; then
      if [ -z "$DB_DUMP_VARIANT" ]; then
        echo "DB_DUMP_VARIANT is required when FILE_URL is not set"
        echo "Example: europe/germany/photon-db-germany-1.0-latest"
        exit 1
      fi

      DB_DUMP_VARIANT="''${DB_DUMP_VARIANT#/}"
      FILE_URL="''${BASE_URL%/}/$DB_DUMP_VARIANT.tar.bz2"
    fi

    RELEASE_ID="$(printf '%s' "$FILE_URL" | md5sum | awk '{print $1}')"
    TARGET_RELEASE_DIR="$RELEASES_ROOT/$RELEASE_ID"
    TARGET_RELEASE_DB_DIR="$TARGET_RELEASE_DIR/photon_data"

    CURRENT_ACTIVE_DIR=""
    if [ -L "$ACTIVE_DB_LINK" ]; then
      CURRENT_ACTIVE_DIR="$(readlink -f "$ACTIVE_DB_LINK" 2>/dev/null || true)"
    fi

    if [ -f "$ACTIVE_DATA_FILE" ]; then
      CANDIDATE_FROM_FILE="$(cat "$ACTIVE_DATA_FILE")"
      if [ -n "$CANDIDATE_FROM_FILE" ] && [ -d "$CANDIDATE_FROM_FILE" ]; then
        CURRENT_ACTIVE_DIR="$CANDIDATE_FROM_FILE"
      fi
    elif [ -d "$LEGACY_V1_ES_DIR" ]; then
      CURRENT_ACTIVE_DIR="$DATA_DIR/photon_data"
    fi

    if [ -n "$CURRENT_ACTIVE_DIR" ] && [ -d "$CURRENT_ACTIVE_DIR" ] && ! bool_true "$DB_DUMP_FORCE_DOWNLOAD"; then
      if [ -f "$INDEX_SOURCE_FILE" ]; then
        CURRENT_SOURCE_URL="$(cat "$INDEX_SOURCE_FILE")"
        if [ "$CURRENT_SOURCE_URL" = "$FILE_URL" ]; then
          echo "Photon index already active at $CURRENT_ACTIVE_DIR and matches requested dump, skipping download"
          exit 0
        fi

        echo "Detected dump change: current=$CURRENT_SOURCE_URL requested=$FILE_URL"
        if [ -d "$TARGET_RELEASE_DIR" ] && [ -d "$TARGET_RELEASE_DB_DIR" ]; then
          echo "Requested dump already downloaded, switching active release without re-download"
          activate_release "$TARGET_RELEASE_DIR"
          exit 0
        fi
      else
        echo "Photon index already present at $CURRENT_ACTIVE_DIR but no source marker found, skipping download"
        echo "Set DB_DUMP_FORCE_DOWNLOAD=true to replace existing data"
        exit 0
      fi
    fi

    ARCHIVE_PATH="$DATA_TMP_DIR/photon-db.tar.bz2"
    MD5_PATH="$DATA_TMP_DIR/photon-db.tar.bz2.md5"
    STAGING_ROOT="$DATA_TMP_DIR/staging"
    STAGING_DB_DIR="$STAGING_ROOT/photon_data"

    if [ -d "$TARGET_RELEASE_DB_DIR" ] && ! bool_true "$DB_DUMP_FORCE_DOWNLOAD"; then
      echo "Requested dump already exists locally: $TARGET_RELEASE_DIR"
      activate_release "$TARGET_RELEASE_DIR"
      exit 0
    fi

    echo "Downloading photon index from $FILE_URL"
    download_with_resume_and_progress "$FILE_URL" "$ARCHIVE_PATH" "$PROGRESS_INTERVAL_SECONDS"

    if ! bool_true "$SKIP_MD5_CHECK"; then
      if [ -z "$MD5_URL" ]; then
        MD5_URL="$FILE_URL.md5"
      fi

      echo "Downloading checksum from $MD5_URL"
      curl -fL --retry 5 --retry-all-errors --connect-timeout 20 --max-time 0 -o "$MD5_PATH" "$MD5_URL"

      EXPECTED_MD5="$(awk '{print $1}' "$MD5_PATH")"
      ACTUAL_MD5="$(md5sum "$ARCHIVE_PATH" | awk '{print $1}')"

      if [ -z "$EXPECTED_MD5" ] || [ "$EXPECTED_MD5" != "$ACTUAL_MD5" ]; then
        echo "Checksum mismatch (expected=$EXPECTED_MD5 actual=$ACTUAL_MD5)"
        exit 1
      fi

      echo "Checksum verified"
    else
      echo "Skipping checksum validation"
    fi

    echo "Extracting archive into staging dir: $STAGING_ROOT"
    rm -rf "$STAGING_ROOT"
    mkdir -p "$STAGING_ROOT"
    tar -xjf "$ARCHIVE_PATH" -C "$STAGING_ROOT"

    if [ ! -d "$STAGING_DB_DIR" ]; then
      echo "Archive extracted but expected staging dir is missing: $STAGING_DB_DIR"
      exit 1
    fi

    if bool_true "$DB_DUMP_FORCE_DOWNLOAD" && [ -d "$TARGET_RELEASE_DIR" ]; then
      echo "DB_DUMP_FORCE_DOWNLOAD=true, removing existing release dir: $TARGET_RELEASE_DIR"
      rm -rf "$TARGET_RELEASE_DIR"
    fi

    mkdir -p "$RELEASES_ROOT"
    if [ ! -d "$TARGET_RELEASE_DB_DIR" ]; then
      echo "Storing release in: $TARGET_RELEASE_DIR"
      mkdir -p "$TARGET_RELEASE_DIR"
      mv "$STAGING_DB_DIR" "$TARGET_RELEASE_DB_DIR"
    else
      echo "Release dir already exists, reusing: $TARGET_RELEASE_DIR"
    fi

    rm -rf "$STAGING_ROOT"

    if [ ! -d "$TARGET_RELEASE_DB_DIR" ]; then
      echo "Activated Photon DB is invalid, missing: $TARGET_RELEASE_DB_DIR"
      exit 1
    fi

    activate_release "$TARGET_RELEASE_DIR"

    echo "Photon index ready"
  '';
in
{
  image-amd64 = containerSupport.buildImage {
    name = "photon";
    version = rootPackage.version;
    rootPackage = rootPackage;
    additionalPackages = [
      photonEntrypoint
      photonDownloader
      pkgs.curl
      pkgs.gnutar
      pkgs.bzip2
      pkgs.gawk
      pkgs.coreutils
    ];
    env = [
      "JAVA_HOME=${pkgs-unstable.jdk21_headless}/lib/openjdk"
      "PHOTON_DATA_DIR=/data"
    ];
    volumes = {
      "/data" = { };
      "/tmp" = { };
    };
    entrypoint = [ "/bin/photon-entrypoint" ];
    basePackageSet = "micro";
    arch = "amd64";
  };
}
