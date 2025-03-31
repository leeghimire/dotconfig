#!/bin/sh 

if [ ! -d /etc/nix-darwin ]; then
    sudo mkdir -p /etc/nix-darwin 
    sudo chown $(id -nu):$(id -ng) /etc/nix-darwin
    sudo ln ./nix-darwin/flake.nix /etc/nix-darwin
fi

nix run --extra-experimental-features 'nix-command flakes' nix-darwin/master#darwin-rebuild -- switch
echo "start a new terminal and run: darwin-rebuild switch"
