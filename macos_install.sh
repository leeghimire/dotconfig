#!/bin/bash
set -euo pipefail

if ! command -v nix >/dev/null 2>&1; then
    echo "Installing Nix..."
    sh <(curl --proto '=https' --tlsv1.2 -sSL https://nixos.org/nix/install)
    echo "Please restart your shell and run this script again."
    exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -d /etc/nix-darwin ]; then
    sudo mkdir -p /etc/nix-darwin
    sudo chown "$(id -nu):$(id -ng)" /etc/nix-darwin
fi

if [ -f nix-darwin/flake.nix ] && [ ! -f /etc/nix-darwin/flake.nix ]; then
    sudo ln -s "$(pwd)/nix-darwin/flake.nix" /etc/nix-darwin/flake.nix
fi

nix run --extra-experimental-features 'nix-command flakes' \
    nix-darwin/master#darwin-rebuild -- switch
