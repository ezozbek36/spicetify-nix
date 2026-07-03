{
  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;

      perSystem = { self, pkgs, ... }:
      let
        spicePkgs = pkgs.extend self.overlays.default;
      in
      {
        formatter = pkgs.nixfmt;

        devShells = {
          default = pkgs.mkShellNoCC { packages = [ pkgs.npins ]; };
          fetcher = pkgs.mkShell {
            packages = builtins.attrValues { inherit (pkgs) rust-analyzer clippy rustfmt; };
            inputsFrom = [ spicePkgs.spicetify.fetcher ];
          };
          docs = pkgs.mkShellNoCC {
            packages = [ pkgs.nodejs ];
            env.SPICETIFY_OPTIONS_JSON = spicePkgs.spicetify.docs.optionsJSON;
          };
        };
      };

      flake = {
        lib = import ./lib { lib = inputs.nixpkgs.lib; };
        overlays.default = import ./overlays;
      } // (import ./modules);
    };
}
