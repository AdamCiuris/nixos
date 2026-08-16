{ config, pkgs, lib, ... }:
{
  services.tailscale.enable = true;
  # Always allow traffic from your Tailscale network
networking.firewall.trustedInterfaces = [ "tailscale0" ];

# Allow the Tailscale UDP port through the firewall
networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

# Strict reverse path filtering breaks Tailscale exit nodes and some subnet routing setups.
networking.firewall.checkReversePath = "loose";

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