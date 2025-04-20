# Container Images for CI-Usage

> [!IMPORTANT]
> This project recently migrated to a nix-based container image build system, the old dockerfiles are still available here: [v1](https://github.com/cidverse/container-images/tree/v1).

## Description

> [!NOTE]
> This project provides various container images for CI/CD usage, including base-images, application iamges and build images.

Types:

- **Base Images**: These images can be extended (strict layer limit to allow user-customization).
- **App Images**: These images are ready to use and can be used in your CI/CD pipelines, these generally include bash and other minimal dependencies required by common CI/CD Services.
- **Build Images**: These images are generally only used at build time and are not intended to be used in production.

We make use of nix `dockerTools` to split each package into a separate layer, allowing for a more efficient caching and storage usage.

All images are available in the following registries:

- http://ghcr.io/cidverse
- https://quay.io/organization/cidverse

## Image Catalog

TODO: ...

## License

Released under the [MIT license](./LICENSE).
