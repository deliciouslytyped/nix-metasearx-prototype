#! /usr/bin/env nix-shell
#! nix-shell -i bash nix/0_tools/extra-container.nix
sudo extra-container create nix/container.nix
sudo extra-container stop search
sudo extra-container start search
