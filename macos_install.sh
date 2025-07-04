#!/bin/sh
set -eu

if [ ! -d /etc/nix-darwin ]; then
  sudo mkdir -p /etc/nix-darwin
  sudo chown "$(id -nu):$(id -ng)" /etc/nix-darwin
fi

if [ ! -f /etc/nix-darwin/flake.nix ]; then
  sudo ln nix-darwin/flake.nix /etc/nix-darwin/flake.nix
fi

nix run --extra-experimental-features 'nix-command flakes' \
    nix-darwin/master#darwin-rebuild -- switch
