{ config, pkgs, lib, ... }:
{
  services.tailscale.enable = true;
  # Always allow traffic from your Tailscale network
networking.firewall.trustedInterfaces = [ "tailscale0" ];

# Allow the Tailscale UDP port through the firewall
networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];


  ### BEGIN EXIT NODE NONSENSE
  # Strict reverse path filtering breaks Tailscale exit nodes and some subnet routing setups.
  networking.firewall.checkReversePath = "loose";
  # 1. Enable IP forwarding for IPv4 and IPv6
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };
  services.tailscale.extraDaemonFlags = [ 
  "--tun=userspace-networking" 
  "--socks5-server=localhost:1055" 
];
  ### END EXIT NODE NONSENSE
networking.nftables = {
  enable = true;
  tables."excludeTraffic" = {
    family = "inet";
    content = ''
      chain excludeOutgoing {
        type route hook output priority -150; policy accept;
        
        # 1. Accept internal overlay traffic sent to the Tailscale interface
        oifname "tailscale0" accept;
        
        # 2. Translate Tailscale daemon mark (0x80000) to Mullvad bypass marks for external connectivity
        meta mark 0x80000 ct mark set 0x00000f41 meta mark set 0x6d6f6c65;
      }
    '';
  };
};
  systemd.services.mullvad-lan-allow = {
      description = "Set Mullvad to allow LAN for Tailscale coexistence";
      requires = [ "mullvad-daemon.service" ];
      after = [ "mullvad-daemon.service" ];
      wantedBy = [ "multi-user.target" ];
      
      script = ''
        # Wait for the Mullvad daemon to be fully ready and responsive
        while ! ${config.services.mullvad-vpn.package}/bin/mullvad status >/dev/null 2>&1; do
          sleep 1
        done
        
        # Enable Local Network Sharing so Tailscale can communicate locally
        ${config.services.mullvad-vpn.package}/bin/mullvad lan set allow
      '';
      
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
    };
}