{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
        inherit (pkgs) lib stdenv makeWrapper jre;
      in
      {
        packages = rec {
          default = tlauncher;
          tlauncher = pkgs.callPackage ./. { };
        };
      });
}
