# platforms=linux/amd64
# image=quay.io/cidverse/osv-scanner

# build
#
FROM quay.io/cidverse/build-go:1.23.2 AS builder

# renovate: datasource=github-releases depName=google/osv-scanner
ARG OSVSCANNER_VERSION=1.8.5

RUN GOBIN=/usr/local/bin/ go install github.com/google/osv-scanner/cmd/osv-scanner@v${OSVSCANNER_VERSION}

# runtime image
#
FROM quay.io/cidverse/base-ubi:9.4-15

COPY --from=builder /usr/local/bin/osv-scanner /usr/local/bin/osv-scanner

RUN osv-scanner --version

CMD ["osv-scanner"]
