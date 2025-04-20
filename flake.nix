{
  description = "NixOS Packages";

  inputs = {
    # official nixpkgs
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-24.11";
    };
    nixpkgs-unstable = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixpkgs-master = {
      url = "github:nixos/nixpkgs/master";
    };

    # user repositories
    nixpkgs-philippheuer = {
      url = "github:philippheuer/nixpkgs/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-unstable,
      nixpkgs-master,
      nixpkgs-philippheuer,
      ...
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      legacyPackages = forAllSystems (
        system:
        import ./default.nix {
          pkgs = import nixpkgs { inherit system; config = { allowUnfree = true; }; };
          pkgs-unstable = import nixpkgs-unstable { inherit system; config = { allowUnfree = true; }; };
          pkgs-master = import nixpkgs-master { inherit system; config = { allowUnfree = true; }; };
          pkgs-ph = import nixpkgs-philippheuer { };
          self = self;
          inputs = inputs;
        }
      );
      packages = forAllSystems (
        system: nixpkgs.lib.filterAttrs (_: v: nixpkgs.lib.isDerivation v) self.legacyPackages.${system}
      );
    };
}
