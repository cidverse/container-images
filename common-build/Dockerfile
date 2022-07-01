# syntax=docker.io/docker/dockerfile:1.3
# platforms=linux/amd64,linux/arm64
# image=quay.io/cidverse/common-build

# runtime image
#
FROM quay.io/cidverse/common-minimal:latest

RUN microdnf install tar xz gzip && microdnf clean all
