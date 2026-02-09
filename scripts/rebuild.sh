#!/usr/bin/env bash

# Path to your config
CONFIG_DIR="$HOME/nixos-config"

echo "--- Pulling latest changes from GitHub ---"
cd "$CONFIG_DIR" && git pull origin main

echo "--- Running NixOS Rebuild ---"
sudo nixos-rebuild switch -I nixos-config="$CONFIG_DIR/config/configuration.nix"

echo "--- Current System Status ---"
fastfetch
