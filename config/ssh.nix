{ pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no"; # Security best practice
    };
  };

  users.users.void.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgB+hEPpEMjBFSTrqGET5UH4CYAMksr9sH8mJ1vSntD yuformini9@gmail.com" # Laptop
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBgLDVhkPrdPrFjjfi+DDojhHH4K91naRO1fCo6oEKhL yuformini9@gmail.com" # Desktop
  ];
}
