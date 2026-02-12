#!/usr/bin/env bash
set -e

echo "--- Pulling latest changes from GitHub ---"
cd "$CONFIG_DIR" && git pull --recurse-submodules && git submodule update --remote --merge

echo "--- Running NixOS Rebuild ---"
sudo nixos-rebuild switch -I nixos-config="$CONFIG_DIR/config/configuration.nix"

echo "--- Current System Status ---"
fastfetch
