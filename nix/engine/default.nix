{callPackage ? (import ./extern/nixpkgs-pinned.nix).callPackage }: {
  nix-searchengine = callPackage ./packages.nix {};
  }
