{ config, pkgs, lib, ... }:
{
  imports = [
    ./caddy.nix
  ];

  # --- AdGuard Home DNS Ad Blocker ---
  ### IMPORTANT
  # https://console.tailscale.com/admin/dns
  # Add this machine's 100.x.y.z to tailscale Global Namersever
  # Tick "override dns servers"
  # there should be a "use with exit node"
  # services.adguardhome = {
  #   enable = true;
  #   settings = {
  #     http = {
  #       # Web UI on port 3000 to avoid conflicts with Caddy on 80/443
  #       address = "0.0.0.0:3000";
  #     };
  #     dns = {
  #       # Listen on all interfaces so Tailscale traffic (tailscale0) can reach it
  #       bind_hosts = [ "0.0.0.0" ];
  #       port = 53;
  #       upstream_dns = [
  #         "https://dns.quad9.net/dns-query"      # Quad9 DNS-over-HTTPS
  #         "https://dns.cloudflare.com/dns-query" # Cloudflare DNS-over-HTTPS
  #       ];
  #     };
  #     filtering = {
  #       protection_enabled = true;
  #       filtering_enabled = true;
  #     };
  #     filters = [
  #       # Pre-configured ad and tracker blocklists
  #       { enabled = true; url = "https://adguardteam.github.io/HostlistsRegistry/assets/filter_1.txt"; name = "AdGuard DNS filter"; }
  #       { enabled = true; url = "https://adaway.org/hosts.txt"; name = "AdAway Default Blocklist"; }
  #     ];
  #   };
  # };

  # --- Tailscale Configuration ---
  services.tailscale = {
    enable = true;
    # Tell the daemon to enable SSH and advertise as an exit node
    extraUpFlags = [ "--ssh" "--advertise-exit-node" ]; 
    useRoutingFeatures = "client";  # Allow the Tailscale UDP port through the firewall
  };

  # --- Firewall and Network Settings ---
  # Always allow traffic from your Tailscale network (automatically allows DNS/UI access)
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
  networking.networkmanager.enable = true;

  # If using systemd-resolved (recommended for split-DNS with Tailscale)
  services.resolved.enable = true;
  networking.networkmanager.dns = "systemd-resolved";

  # --- Exit Node Routing Settings ---
  # Strict reverse path filtering breaks Tailscale exit nodes and subnet routing.
  networking.firewall.checkReversePath = "loose";

  # Enable IP forwarding for both IPv4 and IPv6
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1; 
  };
}