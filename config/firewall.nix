{ ... }:

{
    networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 ];
    trustedInterfaces = [ "tailscale0" ];
  };
}