# syntax=docker.io/docker/dockerfile:1.3
# image=quay.io/cidverse/ansible

# runtime image
#
FROM quay.io/cidverse/common-minimal:latest

# renovate: datasource=pypi depName=ansible
ARG ANSIBLE_VERSION=6.0.0

# renovate: datasource=pypi depName=docker
ARG DOCKER_VERSION=5.0.3

RUN microdnf install -y python3-pip sshpass \
&&  pip3 install --upgrade pip \
&&  pip3 install ansible==${ANSIBLE_VERSION} \
&&  pip3 install docker==${DOCKER_VERSION}

USER 1001
CMD ["ansible"]
