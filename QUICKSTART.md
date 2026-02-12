# Media Server Setup Summary

Complete setup for self-hosted Spotify/Netflix replacement.

## What's Running

| Service | URL | Purpose |
|---------|-----|---------|
| Homepage | http://100.68.33.95:3000 | Dashboard |
| Jellyfin | http://100.68.33.95:8096 | Media streaming (music, movies, TV) |
| Slskd | http://100.68.33.95:5030 | P2P music downloads |

## Common Tasks

### Download Music
1. Open Slskd: http://100.68.33.95:5030
2. Search for artist/song
3. Download FLAC or 320kbps MP3
4. Rescan Jellyfin music library

### Watch Movies/TV
1. Add media to `/srv/jellyfin/media/Movies` or `/srv/jellyfin/media/TV Shows`
2. Follow naming: `Movie Name (Year)/Movie Name (Year).mkv`
3. Rescan Jellyfin library
4. Stream on any device

### Update System
```bash
# On home-server
void-sync        # Pull latest config
nixos-rebuild    # Rebuild system
```

## Storage Layout

```
/srv/jellyfin/
├── media/        # Movies & TV shows
│   ├── Movies/
│   ├── TV Shows/
│   └── Videos/
└── music/        # Music library (Slskd downloads here)
```

**Future**: Mount external drive at `/srv/jellyfin`

## Troubleshooting Quick Reference

### Jellyfin won't start
```bash
cd ~/home-server/docker/jellyfin
docker-compose down
sudo chown -R 1000:1000 config cache
docker-compose up -d
```

### Slskd not connecting
```bash
cd ~/home-server/docker/slskd
docker-compose restart
docker logs slskd | tail -20
```

### Can't access services
- Check Tailscale: `tailscale status`
- Verify IP: Should be 100.68.33.95
- Try direct IP in browser instead of hostname

### Permission errors
```bash
sudo chown -R 1000:1000 /srv/jellyfin
```

## Mobile Apps

**Jellyfin**:
- Android: "Jellyfin for Android" (Play Store)
- iOS: "Jellyfin Mobile" (App Store)
- Login: http://100.68.33.95:8096

## Important Notes

- All services only accessible via Tailscale (secure VPN)
- No public internet exposure
- Hardware transcoding enabled (Intel HD 5500)
- P2P sharing: Slskd shares what you download (Soulseek etiquette)
- Media organized automatically with proper naming

## Next Steps

1. ✅ Download music via Slskd
2. ✅ Add movies/TV to media folders
3. ☐ Export Spotify playlists and batch download
4. ☐ Set up external drive for more storage
5. ☐ Configure Jellyfin mobile apps
6. ☐ Add more users to Jellyfin (family members)

## Full Documentation

- Main: [README.md](/home/ivan/home-server/README.md)
- Jellyfin: [docker/jellyfin/README.md](/home/ivan/home-server/docker/jellyfin/README.md)
- Slskd: [docker/slskd/README.md](/home/ivan/home-server/docker/slskd/README.md)
- Deemix: [docker/deemix/README-DISABLED.md](/home/ivan/home-server/docker/deemix/README-DISABLED.md) (not used)
