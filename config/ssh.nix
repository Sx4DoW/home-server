{ pkgs, ... }:
# Enabled ssh configs and added public keys
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no"; 
    };
  };

  # Hostnames to handle the different modules and submodules
  programs.ssh.extraConfig = ''
    # Primary key for the NixOS config repo
    Host github.com
        HostName github.com
        IdentityFile ~/.ssh/id_nixos

    # Secondary key for the Docker containers submodule
    Host github-containers
        HostName github.com
        IdentityFile ~/.ssh/id_containers
  '';

  # Public ssh keys allowed to remotely connect to this machine
  users.users.void.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgB+hEPpEMjBFSTrqGET5UH4CYAMksr9sH8mJ1vSntD Laptop"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBgLDVhkPrdPrFjjfi+DDojhHH4K91naRO1fCo6oEKhL Desktop"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAKTxhPKn0TPhtawVsLOCsW09qWpXo4LOjHdcaRmTmxf Phone"
  ];
}
