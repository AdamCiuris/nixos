{ config, pkgs, lib, ... }:
{
  services.tailscale.enable = true;
  
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

  # Required for Tailscale exit nodes and subnet routing
  networking.firewall.checkReversePath = "loose";
  
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
  services.resolved.enable = true;
  # 1. Store your private key securely outside the Nix store:
  # sudo mkdir -p /etc/wireguard
  # echo "YOUR_PRIVATE_KEY" | sudo tee /etc/wireguard/mullvad.key
  # sudo chmod 600 /etc/wireguard/mullvad.key
  # Device: Grown Turkey
  networking.wg-quick.interfaces.mullvad = {
    autostart = true;
    privateKeyFile = "/etc/wireguard/mullvad.key"; 
    
    # Replace with the Address values from your Mullvad .conf file
    address = [ 
      "10.65.124.59/32" 
    ];
    
    dns = [ "1.1.1.1" "8.8.8.8" ];    
    peers = [
      {
        # Replace with the PublicKey and Endpoint from your Mullvad .conf file
        publicKey = "BLNHNoGO88LjV/wDBa7CUUwUzPq/fO2UwcGLy56hKy4=";
        endpoint = "87.249.134.27:3152";
        allowedIPs = [ "0.0.0.0/0" "100.64.0.0/10" ];
      }
    ];
  };
}