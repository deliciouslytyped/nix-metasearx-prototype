{ pkgs ? import <nixpkgs> {} }:
let
  extra-container = pkgs.callPackage (builtins.fetchGit {
    url = "https://github.com/erikarvstedt/extra-container.git";
    # Recommended: Specify a git revision hash
    # rev = "...";
  }) {};
in
  pkgs.mkShell { buildInputs = [ extra-container ]; }
