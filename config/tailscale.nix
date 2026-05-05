{ config, pkgs, ... }:
# Tailscale is the VPN of choice to remotely interact with the server 
{
  # Enable the Tailscale daemon
  services.tailscale.enable = true;

  # Open the port Tailscale uses for peer-to-peer connections
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

  # This allows Tailscale's "MagicDNS" and exit nodes to work correctly
  networking.firewall.checkReversePath = "loose";
}
