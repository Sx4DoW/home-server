{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./environment.nix
      ./ssh.nix
      ./tailscale.nix
      ./fastfetch.nix
    ];

  # ----------------------------------------------------

  # Bootloader & Kernel
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # SSD Health
  services.fstrim.enable = true;

  # Hardware Acceleration (NUC QuickSync)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      libvdpau-va-gl
    ];
  };

  # ----------------------------------------------------

  # Networking & Remote Management
  networking.hostName = "home-server";
  services.tailscale.enable = true;
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };

  # Wake on LAN
  networking.interfaces.enp0s25.wakeOnLan.enable = true;

  # Prevent the server from ever auto-sleeping
  systemd.targets.sleep.enable = false;
  systemd.targets.suspend.enable = false;
  systemd.targets.hibernate.enable = false;
  systemd.targets.hybrid-sleep.enable = false;  

  # ----------------------------------------------------

  # User
  users.users.void = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "video" "render" ];
  };

  # ----------------------------------------------------

  # Docker & Lean Maintenance
  virtualisation.docker.enable = true;
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # ----------------------------------------------------

  system.stateVersion = "24.11";

  # ----------------------------------------------------

  # Greeter
  programs.bash.interactiveShellInit = ''
    fastfetch
    echo "Welcome home, void"
  '';
  programs.zsh.interactiveShellInit = ''
    fastfetch
    echo "Welcome home, void"
  '';

  # ----------------------------------------------------
}
