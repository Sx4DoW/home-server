{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    nim
    neovim
    wget
    ncurses
    kitty.terminfo
    git
    htop
    pciutils
  ];

  environment.shellAliases = {
    # System Operations
    nixos-rebuild    = "bash ~/nixos-config/scripts/rebuild.sh";
    nixos-reset      = "bash ~/nixos-config/scripts/hard-reset.sh";
    nixos-edit       = "nano ~/nixos-config/config/configuration.nix";
    nixos-clean      = "sudo nix-collect-garbage -d";

    # Generation Management
    nixos-ls-gens    = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    nixos-go-gen1    = "sudo nix-env --profile /nix/var/nix/profiles/system --switch-generation 1 && sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch";

    # Pinning and Maintenance
    nixos-pin        = "sudo ln -sf /nix/var/nix/profiles/system-$(readlink /nix/var/nix/profiles/system | cut -d- -f2)-link /nix/var/nix/gcroots/pinned-manual-$(date +%F-%H%M)";
    nixos-ls-pinned  = "ls -l /nix/var/nix/gcroots/pinned-* 2>/dev/null | awk '{print $9 \" -> \" $11}'";
    nixos-unpin      = "sudo find /nix/var/nix/gcroots/ -name 'pinned-manual-*' | grep -i";
  };
}
