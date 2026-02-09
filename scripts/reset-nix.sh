#!/usr/bin/env bash

echo "Starting Fresh System Reset..."

# 1. Clear out the old links safely without breaking the current run
# We leave the current 'system' link alone for a second
sudo find /nix/var/nix/profiles/ -name "system-*-link" -delete

# 2. Collect garbage to wipe the old files off the disk
echo "Wiping old files from disk..."
sudo nix-collect-garbage -d

# 3. Rebuild - This will naturally become the new 'Generation 1'
echo "Rebuilding as Generation 1..."
sudo nixos-rebuild switch -I nixos-config=$HOME/nixos-config/configuration.nix

# 4. PINNING: Create the GC Root so it is undeletable
# This tells Nix: "I am using this, don't you dare touch it."
echo "Pinning Generation 1 as a permanent fallback..."
sudo ln -sf /nix/var/nix/profiles/system-1-link /nix/var/nix/gcroots/pinned-stable-gen1

echo "----------------------------------------"
echo "Done! Generation 1 is now pinned and immune to auto-GC."
echo "Current generations:"
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system
