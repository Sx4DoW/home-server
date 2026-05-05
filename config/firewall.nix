{ ... }:
# Firewall rules.
# All incoming connections are dropped
# if not on allowed ports or trusted interface (VPN)
{
    networking.firewall = {
    enable = true;
    # 50300 is slskd port
    allowedTCPPorts = [ 80 443 50300];
    allowedUDPPorts = [ 50300 ];
    trustedInterfaces = [ "tailscale0" ];
  };
}