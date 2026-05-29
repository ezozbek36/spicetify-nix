{ pkgs ? import <nixpkgs> { } }: {
  lib = import ./lib { lib = pkgs.lib; };
}
// (import ./modules)
