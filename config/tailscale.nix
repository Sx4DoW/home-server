{ config, pkgs, ... }:

{
  # Enable the Tailscale daemon
  services.tailscale.enable = true;

  # Open the port Tailscale uses for peer-to-peer connections
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

  # This allows Tailscale's "MagicDNS" and exit nodes to work correctly
  # by relaxing the reverse path filtering.
  networking.firewall.checkReversePath = "loose";
}
