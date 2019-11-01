self: super:
 {
  #todo not using makeoverridable causes ''' value is a function while a set was expected ''' in bootstrap; makeExtensible; for some reason
  engine = self.nixpkgs.lib.makeOverridable ({ plugins ? [] }:
    self.nixpkgs.runCommand "lol" {} ''
        mkdir -p $out
        pushd $out
        ${self.nixpkgs.lib.concatMapStringsSep "\n" (p: "ln -s '${p}' '${builtins.baseNameOf p}'") plugins}
        '') {};
  }
