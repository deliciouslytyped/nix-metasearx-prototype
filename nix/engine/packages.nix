{lib, callPackage}:
let rooted = callPackage ./extern/nix-rootedoverlay2/rooted.nix {};
    inherit (rooted.lib) interface overlays;
in
  rooted.mkRoot {
    interface = interface.default (self: self.engine); #TODO make tempwrapper autoevel to its default arguments by default in rootedoverlay
    layers = overlays.autoimport2 ./layers;
    }
