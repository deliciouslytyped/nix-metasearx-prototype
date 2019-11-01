{pkgs, lib, ...}:
let
  inherit (import ./engine {}) nix-searchengine;
  engine = nix-searchengine.withPackages (p: with p; [ IRC commitlogs ]);
in
{
  containers.search = {

    privateNetwork = true;
    hostAddress = "10.250.0.1";
    localAddress = "10.250.0.3";

    config = { pkgs, ... }: {
      environment.systemPackages = [
        engine #todo unused
        ];

      networking.firewall.allowedTCPPorts = [ 80 443 8888 ];

      services.searx = {
        enable = true;
        configFile = ./searx.yml;
        #todo override python flask and           patches = [ (reversedPatch) ];
        package = (pkgs.searx.override (old: {
          python3Packages = (pkgs.python3.override { packageOverrides =

            let
              flaskPatch = pkgs.fetchpatch {
                url = "https://github.com/pallets/werkzeug/commit/726b25bdf9b7786641e19f50692b4895f3cfc3a7.patch";
                sha256 = "sha256:0c6kqhikxdl9vk6n5bl5kl1bqa2nmbpwwdlgdxkcg6zg31l24l4f";
                };
              reversedPatch = pkgs.runCommand "revflaskPatch" { buildInputs = [ pkgs.patchutils ]; } ''
                interdiff -q '${flaskPatch}' /dev/null > $out
                '';
            in
              (self: super: {
                werkzeug = super.werkzeug.overrideAttrs (old: {
                  patches = (old.patches or []) ++ [ reversedPatch ];
                  });

                });
            }).pkgs; # todo is this correct?

          })).overrideAttrs (old: {
            src = lib.cleanSource ./../searx;
            });
        };

      services.hound = {
        enable = true;
        config = ''
        {
          "max-concurrent-indexers": 2,
          "dbpath": "/var/lib/hound/data",
          "repos": {
            "nix": {
              "url": "file://${engine.IRC}"
              }
            }
          }
          '';
        };

/*
      systemd.services.houndseed = {
        description = "seed hound";
        requiredBy = [ "hound.service" ];
        before = [ "hound.service" ];

        serviceConfig = {
          User = "hound";
          Group = "hound";
          WorkingDirectory = "/var/lib/hound";
        };
#TODO
        path = [ engine ]; # ???
        script = ''
          pushd /var/lib/hound/
          ln -s $(searchenginepath-IRC) IRC
          ln -s $(searchenginepath-commitlogs) commitlogs
          '';
      };
*/

    };
  };
}
