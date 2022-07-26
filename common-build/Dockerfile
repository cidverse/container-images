# syntax=docker.io/docker/dockerfile:1.3
# platforms=linux/amd64
# image=quay.io/cidverse/common-build

# runtime image
#
FROM quay.io/cidverse/common-minimal:latest

ADD scripts/* /usr/local/bin
ADD files/dnf.conf /etc/dnf/dnf.conf

RUN microdnf install -y tar xz gzip unzip git gpg jq \
&&  microdnf clean all \
&&  mkdir -p /cache
