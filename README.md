# Home Server Configuration

This repository contains the complete NixOS configuration for my home server, managed through a GitHub-centric workflow that separates development (laptop) from deployment (server).

## Overview

This setup transforms a standard NixOS installation into a **version-controlled deployment target**. All configuration changes are made on a laptop, pushed to GitHub, and automatically pulled and applied by the server. The server has read-only access to the repository, ensuring security even if the server is compromised.

---

## Architecture

### GitHub-Centric Workflow

**Source of Truth:** All configuration lives in this private GitHub repository (`Sx4DoW/home-server`).

**Control Center (Laptop):** Edit files in VS Code, commit changes, and push to GitHub.

**Deployment Target (Server):** The server pulls updates from GitHub and applies them. The server's SSH key has no passphrase and is configured as a read-only deploy key.

### Directory Structure

```md
home-server/
├── config/                 # NixOS configuration modules
│   ├── configuration.nix       # Main system configuration
│   ├── environment.nix         # Packages, aliases, and environment variables
│   ├── ssh.nix                 # SSH daemon and authorized keys
│   ├── tailscale.nix           # Tailscale VPN configuration
│   ├── fastfetch.nix           # Custom system info display
│   └── hardware-configuration.nix
└── scripts/                # Automation scripts
    ├── rebuild.sh              # Pull from Git and rebuild system
    └── hard-reset.sh           # Wipe generations and reset to Gen 1
```

---

## Management Commands

Custom aliases are defined in [environment.nix](config/environment.nix) to simplify system management:

### System Operations

| Command | Function |
| --- | --- |
| `nixos-rebuild` | Pull latest changes from GitHub and rebuild the system |
| `nixos-reset` | Wipe all generations, clean garbage, and reset to Generation 1 |
| `nixos-edit` | Open the main configuration file in nano |
| `nixos-clean` | Run garbage collection to free up disk space |

### Generation Management

| Command | Function |
| --- | --- |
| `nixos-ls-gens` | List all previous system versions (generations) |
| `nixos-go-gen1` | Roll back to Generation 1 and activate it |

### Pinning and Maintenance

| Command | Function |
| --- | --- |
| `nixos-pin` | Mark the current generation as "pinned" to prevent deletion |
| `nixos-ls-pinned` | List all pinned generations |
| `nixos-unpin` | Search for pinned generations (use with `xargs rm` to unpin) |

---

## Configuration Details

### System Specifications

- **Hostname:** `home-server`
- **User:** `void` (with sudo access via `wheel` group)
- **Bootloader:** systemd-boot with EFI support
- **Kernel:** Latest Linux kernel (`pkgs.linuxPackages_latest`)
- **SSD Optimization:** TRIM enabled for SSD health

### Hardware Acceleration

Intel QuickSync support enabled for hardware video encoding/decoding:

```nix
hardware.graphics = {
  enable = true;
  extraPackages = [ intel-media-driver libvdpau-va-gl ];
};
```

### Networking & Remote Access

**SSH Configuration** ([ssh.nix](config/ssh.nix)):

- Password authentication disabled
- Keyboard-interactive authentication disabled
- Root login disabled
- Three authorized keys (laptop, desktop, phone)

**Tailscale VPN** ([tailscale.nix](config/tailscale.nix)):

- Tailscale daemon enabled
- MagicDNS and exit nodes configured
- UDP port opened in firewall
- Reverse path filtering set to "loose"

**Wake-on-LAN:**

- Enabled on interface `enp0s25`

**Power Management:**

- Sleep, suspend, hibernate, and hybrid-sleep all disabled to keep the server always-on

### Installed Packages

System packages defined in [environment.nix](config/environment.nix):

- **Editors:** `neovim`, `nano`
- **Development:** `nim`, `git`
- **Utilities:** `wget`, `htop`, `pciutils`, `ncurses`
- **Terminal:** `kitty.terminfo` (for proper terminal emulation over SSH)
- **System Info:** `fastfetch`

### Docker Support

Docker is enabled with the `void` user added to the `docker` group for container management:

```nix
virtualisation.docker.enable = true;
users.users.void.extraGroups = [ "wheel" "docker" "video" "render" ];
```

### Automatic Maintenance

**Nix Store Optimization:**

- Auto-optimize store enabled to deduplicate files
- Automatic garbage collection runs weekly
- Automatically deletes generations older than 7 days

```nix
nix.settings.auto-optimise-store = true;
nix.gc = {
  automatic = true;
  dates = "weekly";
  options = "--delete-older-than 7d";
};
```

### Custom System Info Display

Fastfetch is configured to display on login ([fastfetch.nix](config/fastfetch.nix)) showing:

- OS and uptime
- Local IP and Tailscale IP
- Current generation number and pinned generation count
- CPU (with temperature), RAM, and disk usage
- Docker container status (running/total)
- Color palette

---

## Environment Variables

The global variable `$CONFIG_DIR` is set to `$HOME/home-server` in [environment.nix](config/environment.nix), ensuring scripts and aliases always reference the correct configuration directory regardless of your current working directory.

---

## Scripts

### rebuild.sh

Pulls the latest configuration from GitHub and applies it:

1. Pulls from `origin/main`
2. Runs `sudo nixos-rebuild switch`
3. Displays system status with `fastfetch`

Uses `set -e` to exit immediately on any error.

### hard-reset.sh

## WARNING: Destructive operation

This script:

1. Prompts for confirmation (y/N)
2. Removes all generation links
3. Runs full garbage collection (`nix-collect-garbage -d`)
4. Rebuilds from scratch as Generation 1
5. Pins the new Generation 1 as `pinned-stable-base`

Use this to recover from a broken system state or to start fresh.

---

## Security Considerations

1. **Read-Only Deploy Key:** The server's SSH key has read-only access to GitHub, preventing unauthorized pushes even if the server is compromised.

2. **No SSH Passphrase on Server:** The deploy key has no passphrase to allow automated git pulls, but this is mitigated by the read-only restriction.

3. **Password Authentication Disabled:** Only SSH key authentication is allowed.

4. **Root Login Disabled:** Direct root SSH access is blocked.

5. **Version Control:** All changes are tracked in Git, providing full audit history and rollback capability.

---

## Usage Workflow

### Making Changes

1. **On your laptop:** Edit configuration files in VS Code
2. **Commit:** `git commit -am "Description of changes"`
3. **Push:** `git push origin main`
4. **On the server:** Run `nixos-rebuild` (which pulls and applies)

### Rolling Back

If a change breaks the system:

```bash
sudo nixos-rebuild switch --rollback
```

Or switch to a specific generation:

```bash
nixos-ls-gens                # Find the generation number
sudo nix-env --profile /nix/var/nix/profiles/system --switch-generation <number>
sudo /nix/var/nix/profiles/system/bin/switch-to-configuration switch
```

### Monitoring System State

Check the current state at any time:

```bash
fastfetch                # See generation, IPs, Docker status, etc.
nixos-ls-gens            # View generation history
nixos-ls-pinned          # Check protected generations
```

---

## Initial Setup

This configuration assumes:

- NixOS 24.11 or later
- The repository is cloned to `~/home-server`
- A read-only GitHub deploy key is configured
- SSH keys are added to [ssh.nix](config/ssh.nix)

To apply this configuration on a fresh NixOS install:

```bash
cd ~/home-server
sudo nixos-rebuild switch -I nixos-config="$HOME/home-server/config/configuration.nix"
```

After the first rebuild, use `nixos-rebuild` instead.
