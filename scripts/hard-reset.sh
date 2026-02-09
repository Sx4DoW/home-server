#!/usr/bin/env bash

CONFIG_DIR="$HOME/nixos-config"

echo "CRITICAL: This will wipe all generations and reset to Generation 1."
read -p "Continue? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

echo "--- Removing old profiles ---"
sudo find /nix/var/nix/profiles/ -name "system-*-link" -delete

echo "--- Running Garbage Collection ---"
sudo nix-collect-garbage -d

echo "--- Rebuilding Fresh Generation 1 ---"
sudo nixos-rebuild switch -I nixos-config="$CONFIG_DIR/config/configuration.nix"

echo "--- Pinning current state as stable base ---"
sudo ln -sf /nix/var/nix/profiles/system-1-link /nix/var/nix/gcroots/pinned-stable-base

echo "--- Reset Complete ---"
