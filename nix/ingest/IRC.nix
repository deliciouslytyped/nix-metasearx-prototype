{pkgs ? import <nixpkgs> {} }:
  pkgs.runCommand "IRC" {} ''
    ln -s ${./logs} logs
    ''
