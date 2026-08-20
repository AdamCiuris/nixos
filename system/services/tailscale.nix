{ config, pkgs, lib, ... }:
{
  services.tailscale = {
    enable = true;
    # Tell the daemon to enable SSH and advertise as an exit node
    extraUpFlags = [ "--ssh" "--advertise-exit-node" ]; 
  };

  # Always allow traffic from your Tailscale network
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # Allow the Tailscale UDP port through the firewall
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

  ### BEGIN EXIT NODE SETTINGS
  # Strict reverse path filtering breaks Tailscale exit nodes and subnet routing.
  networking.firewall.checkReversePath = "loose";

  # Enable IP forwarding for both IPv4 and IPv6
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1; 
  };
  ### END EXIT NODE SETTINGS
}
