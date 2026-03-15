{ ... }:

{
    networking.firewall = {
    enable = true;
    # 50300 is slskd port
    allowedTCPPorts = [ 80 443 50300];
    allowedUDPPorts = [ 50300 ];
    trustedInterfaces = [ "tailscale0" ];
  };
}