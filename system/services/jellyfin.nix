{ config, pkgs, lib, ... }:

{
  # Enable the Jellyfin media server
  services.jellyfin = {
    enable = true;
    user = "nyx"; # need this to be able to access user directories
    # We set this to false because we want to explicitly restrict 
    # access to the Tailscale network below, rather than opening it globally.
    openFirewall = false; 
  };

  # Enable the Tailscale background daemon
  services.tailscale.enable = true;

  # Open Jellyfin's web port (8096) ONLY on the Tailscale interface
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 8096 ];

  # (Optional) Add the packages to your system environment if you want 
  # to run their CLI tools directly, though the systemd service manages 
  # its own isolated environment with these automatically.
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    tailscale
  ];
}