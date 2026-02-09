{ pkgs, ... }:

{

  environment.variables = {
    CONFIG_DIR = "$HOME/home-server";
  };

  environment.systemPackages = with pkgs; [
    nim
    neovim
    wget
    ncurses
    kitty.terminfo
    git
    htop
    pciutils
    tmux
    docker-compose
  ];

  environment.shellAliases = {
    # System Operations
    nixos-rebuild    = "bash $CONFIG_DIR/scripts/rebuild.sh";
    nixos-reset      = "bash $CONFIG_DIR/scripts/hard-reset.sh";
    nixos-edit       = "nano $CONFIG_DIR/config/configuration.nix";
    nixos-clean      = "sudo nix-collect-garbage -d";

    # Generation Management
    nixos-ls-gens    = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    nixos-go-gen1    = "sudo nix-env --profile /nix/var/nix/profiles/system --switch-generation 1 && sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch";

    # Pinning and Maintenance
    nixos-pin        = "sudo ln -sf /nix/var/nix/profiles/system-$(readlink /nix/var/nix/profiles/system | cut -d- -f2)-link /nix/var/nix/gcroots/pinned-manual-$(date +%F-%H%M)";
    nixos-ls-pinned  = "ls -l /nix/var/nix/gcroots/pinned-* 2>/dev/null | awk '{print $9 \" -> \" $11}'";
    nixos-unpin      = "sudo find /nix/var/nix/gcroots/ -name 'pinned-manual-*' | grep -i";

    # Docker
    dps  = "docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'";
    dlog = "docker logs -f";

    # Git sync
    void-sync = "cd ~/home-server && git pull && cd docker && git pull origin main && cd ..";
  };
}
