# Documentation Index

Complete reference for home-server setup.

## 📋 Quick Links

| Document                                 | Purpose                                         |
|------------------------------------------|-------------------------------------------------|
| [QUICKSTART.md](QUICKSTART.md)           | **Start here** - Common tasks & quick reference |
| [ARCHITECTURE.md](ARCHITECTURE.md)       | System design & workflow                        |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | Common issues & solutions                       |
| [README.md](README.md)                   | Full project documentation                      |

## 🚀 Getting Started

**New to this setup?**

1. Read [QUICKSTART.md](QUICKSTART.md) - 5 min overview
2. Check [ARCHITECTURE.md](ARCHITECTURE.md) - Understand the system
3. Bookmark [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - For when things break

## 📦 Service Documentation

### Active Services

- **[Jellyfin](docker/jellyfin/README.md)** - Media server
  - Streaming movies, TV shows, music
  - Hardware acceleration setup
  - Mobile app configuration
  
- **[Slskd](docker/slskd/README.md)** - P2P music downloads
  - Spotify playlist workflow
  - Quality guidelines
  - No VPN needed

- **[Homepage](docker/homepage/)** - Dashboard
  - Service links
  - Container monitoring

- **[Power Monitor](docker/power-monitor/README.md)** - Energy and cost tracking
  - Live server power estimates
  - Monthly cost history (SQLite)

### Disabled Services

- **[Deemix](docker/deemix/README-DISABLED.md)** - Not in use
  - Geo-blocking issues in Italy
  - VPN setup preserved for future

## 🎯 Common Tasks

### Download Music

1. Open [Slskd](http://100.68.33.95:5030)
2. Search artist/song
3. Download FLAC or 320kbps
4. Rescan Jellyfin

### Add Movies/TV

1. Copy to `/srv/jellyfin/media/Movies` or `/srv/jellyfin/media/TV Shows`
2. Follow naming: `Movie Name (Year)/Movie Name (Year).mkv`
3. Rescan Jellyfin library

### Update Configuration

```bash
# On archlinux
cd ~/home-server
# Edit files
git add . && git commit -m "..." && git push

# On home-server
void-sync && nixos-rebuild
```

### Fix Permissions

```bash
sudo chown -R 1000:1000 /srv/jellyfin
sudo chown -R 1000:1000 ~/home-server/docker/<service>/config
```

## 🔧 System Commands

```bash
# Sync & rebuild
void-sync              # Pull git changes
nixos-rebuild          # Apply NixOS config

# Docker management
dps                    # List containers
dlog <name>           # View logs
cd ~/home-server/docker/<service>
docker-compose restart # Restart service

# System info
tailscale status      # Network status
df -h                 # Disk usage
htop                  # Resource usage
```

## 🌐 Service URLs

All via Tailscale (100.68.33.95):

- Homepage: <http://100.68.33.95:3000>
- Jellyfin: <http://100.68.33.95:8096>  
- Slskd: <http://100.68.33.95:5030>
- Power Monitor: <http://100.68.33.95:9150>

## 📱 Mobile Access

**Jellyfin Apps:**

- Android: "Jellyfin for Android"
- iOS: "Jellyfin Mobile"
- Server: <http://100.68.33.95:8096>

## 🗂️ Directory Structure

```md
/home/ivan/home-server/     # Git repo
├── config/                 # NixOS configs
├── docker/                 # Services
│   ├── homepage/
│   ├── jellyfin/
│   ├── slskd/
│   └── power-monitor/
├── scripts/                # Maintenance
├── QUICKSTART.md          # You are here
├── ARCHITECTURE.md        # System design
└── TROUBLESHOOTING.md     # Problem solving

/srv/jellyfin/             # Media storage
├── media/                 # Movies & TV
└── music/                # Music library
```

## ⚠️ Important Notes

- ✅ All services Tailscale-only (secure)
- ✅ home-server has read-only git (security)
- ✅ Hardware transcoding enabled
- ✅ No public internet exposure
- ⚠️ Media not backed up (can re-download)
- ⚠️ Commit config changes regularly

## 🆘 Emergency

**Service broken?**

```bash
cd ~/home-server/docker/<service>
docker-compose down
sudo rm -rf config
docker-compose up -d
```

**System broken?**

```bash
nixos-ls-gens        # List generations
nixos-go-gen1        # Rollback
# Or: Reboot → GRUB → Select generation
```

**Can't access?**

- Check Tailscale: `tailscale status`
- Use IP: <http://100.68.33.95:PORT>
- Try incognito browser

## 📚 Need More Help?

1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. View logs: `docker logs <service>`
3. Read service docs: `docker/<service>/README.md`
4. System logs: `journalctl -xe`

---

**Last Updated**: Context about to reset - all important info is now in these docs! 🚀
