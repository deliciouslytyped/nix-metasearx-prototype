{super}:
#todo this feels redundant
super.nixpkgs.stdenv.mkDerivation {
  pname = "IRC";
  version = "somedate"; #TODO date
  phases = [ "installPhase" ];
  src = ./temp/irc;
  installPhase = ''
    mkdir -- "$out"
    cp -r $src/* $out
    '';
  }

