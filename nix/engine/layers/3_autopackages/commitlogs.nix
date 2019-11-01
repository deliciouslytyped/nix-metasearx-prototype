{super}: #super.copyPathToStore ./temp/commitlogs
#todo this feels redundant
super.nixpkgs.stdenv.mkDerivation {
  pname = "IRC";
  version = "somedate"; #TODO date
  phases = [ "installPhase" ];
  src = ./temp/commitlogs;
  installPhase = ''
    mkdir -- "$out"
    cp -r $src/* $out
    '';
  }

