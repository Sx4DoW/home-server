# System Architecture & Workflow

## Network Topology

```
Internet
    │
    ├─ archlinux (100.78.206.128)
    │  └─ Development machine
    │     - Edit configurations
    │     - Commit & push to GitHub
    │
    └─ home-server (100.68.33.95)
       └─ NixOS production server
          - Read-only git access
          - Pulls config changes
          - Runs Docker services

All connected via Tailscale VPN (trusted network)
```

## Services Architecture

```
home-server (NixOS)
│
├─ System Level (NixOS)
│  ├─ Firewall (ports 80/443, Tailscale trusted)
│  ├─ Docker daemon
│  └─ Shell aliases & scripts
│
└─ Docker Services
   ├─ Homepage:3000 (Dashboard)
   ├─ Jellyfin:8096 (Media server with HW accel)
   └─ Slskd:5030 (P2P music downloader)

Storage: /srv/jellyfin/
├─ media/ (movies, TV)
└─ music/ (from Slskd)
```

## Development Workflow

### 1. Edit Configuration (archlinux)
```bash
cd ~/home-server
# Edit files in config/, docker/*, scripts/
```

### 2. Commit & Push
```bash
git add .
git commit -m "Description"
git push
```

### 3. Deploy to Server (home-server)
```bash
# SSH to home-server or directly:
void-sync              # Pulls git changes
nixos-rebuild          # If NixOS config changed

# Or for Docker services only:
cd ~/home-server/docker/<service>
docker-compose up -d
```

## File Organization

```
/home/ivan/home-server/     # Git repo
├── config/                 # NixOS configuration
│   ├── configuration.nix   # Main config
│   ├── docker.nix         # Docker setup
│   ├── environment.nix    # Packages & aliases
│   ├── firewall.nix       # Network rules
│   └── ...
├── docker/                # Docker services
│   ├── homepage/          # Dashboard
│   ├── jellyfin/          # Media server
│   ├── slskd/            # Music downloader
│   └── deemix/           # (Disabled)
├── scripts/              # Helper scripts
│   ├── rebuild.sh       # nixos-rebuild alias
│   └── hard-reset.sh    # Emergency recovery
├── QUICKSTART.md        # This file
├── TROUBLESHOOTING.md   # Common issues
└── README.md            # Full documentation

/srv/jellyfin/            # Media storage
├── media/               # Movies & TV
└── music/              # Music library
```

## Key Commands Reference

### System Management
```bash
void-sync               # Pull latest config from git
nixos-rebuild          # Rebuild NixOS (runs rebuild.sh)
nixos-clean           # Clear old generations
nixos-ls-gens         # List all generations
```

### Docker Management
```bash
dps                    # List containers (formatted)
dlog <container>       # Follow container logs
docker-compose up -d   # Start service
docker-compose down    # Stop service
docker-compose restart # Restart service
```

### Service URLs
```bash
# All accessible via Tailscale at 100.68.33.95
Homepage:  http://100.68.33.95:3000
Jellyfin:  http://100.68.33.95:8096
Slskd:     http://100.68.33.95:5030
```

## Security Model

- **No public internet exposure**: All services Tailscale-only
- **Read-only git**: home-server can't push changes
- **Service isolation**: Each service in Docker container
- **Firewall**: Only 80/443 open, Tailscale interface trusted
- **No passwords in git**: Use .env files (gitignored)

## Backup Strategy

- **Configuration**: Backed up via git (GitHub)
- **Media files**: Not backed up (can re-download)
- **Recommendations**:
  - Regular git commits from archlinux
  - Pin working NixOS generations
  - Keep important media on external drive

## Expansion Planning

### Adding New Services
1. Create `docker/<service>/docker-compose.yml`
2. Add README in service directory
3. Update homepage config
4. Commit & push from archlinux
5. Pull & start on home-server

### Adding External Storage
```bash
# Mount drive at /srv/jellyfin
sudo mount /dev/sdX1 /srv/jellyfin
# Add to fstab for persistence
```

### Adding Users to Jellyfin
Dashboard → Users → Add User (with passwords)

## Monitoring

```bash
# System resources
htop

# Container status
docker ps
docker stats

# View all logs
docker-compose logs -f

# Disk usage
df -h /srv/jellyfin
```

## Quick Recovery

### Service Won't Start
```bash
cd ~/home-server/docker/<service>
docker-compose down
docker-compose up -d
docker logs <service>
```

### Permissions Broken
```bash
sudo chown -R 1000:1000 /srv/jellyfin
sudo chown -R 1000:1000 ~/home-server/docker/<service>/config
```

### System Broken
```bash
# Rollback to previous generation
nixos-ls-gens
nixos-go-gen1  # Or whichever works
# Or select from GRUB menu on reboot
```

---

**For detailed troubleshooting**: See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
**For quick reference**: See [QUICKSTART.md](QUICKSTART.md)
**For service docs**: See `docker/*/README.md`
