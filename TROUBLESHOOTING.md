# Known Issues & Solutions

## Jellyfin

### Container Restarting (Exit 139)
**Cause**: Permission denied on config/cache directories

**Solution**:
```bash
cd ~/home-server/docker/jellyfin
docker-compose down
sudo chown -R 1000:1000 config cache
docker-compose up -d
```

### Hardware Acceleration Not Working
**Cause**: Wrong render group ID or not enabled in settings

**Solution**:
1. Check group: `getent group render | cut -d: -f3`
2. Update docker-compose.yml if not 109
3. Enable in: Dashboard → Playback → Intel Quick Sync (QSV)

### Can't Access Web UI
**Solutions**:
- Use IP: http://100.68.33.95:8096 instead of hostname
- Check Tailscale: `tailscale status`
- Verify container: `docker ps | grep jellyfin`

## Slskd

### 401 Unauthorized Error
**Cause**: Web authentication credentials issue

**Solution**: Already fixed - auth is disabled in config/slskd.yml

### Username Already Taken  
**Cause**: Soulseek username in use

**Solution**: Edit config/slskd.yml, change username, restart

### Can't Download Files
**Cause**: User might be offline or sharing restrictions

**Solution**: Try different search results, look for users with many files

## General

### Services Not Accessible
**Checklist**:
1. On Tailscale network? `tailscale status`
2. Container running? `docker ps`
3. Correct IP? Use 100.68.33.95
4. Try incognito browser (clear cache)

### Permission Errors
**Solution**:
```bash
# Fix jellyfin storage
sudo chown -R 1000:1000 /srv/jellyfin

# Fix docker configs
cd ~/home-server/docker/<service>
sudo chown -R 1000:1000 config
```

### Git Push Refused
**Cause**: home-server has read-only git access (by design)

**Solution**: Always push from archlinux, pull on home-server

### Docker Compose Commands Not Found
**Solution**: Already available - use `docker-compose` (with hyphen)

## Deemix (Disabled)

### Why Not Using?
- Deezer geo-blocked in Italy
- VPN setup too complex
- Slskd is simpler alternative

### Can I Re-enable?
Yes, files still in docker/deemix/, but need ProtonVPN setup complete.

## Recovery

### Complete Service Reset
```bash
cd ~/home-server/docker/<service>
docker-compose down
sudo rm -rf config cache data
docker-compose up -d
```

### System Rollback
```bash
nixos-ls-gens              # List generations
nixos-go-gen1             # Go to generation 1
# Or reboot and select from GRUB menu
```

### Check All Services
```bash
dps                        # List containers
docker ps -a              # Include stopped containers
docker-compose ps         # In service directory
```
