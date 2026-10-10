{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    mullvad-browser
  ];

  systemd.services."nixosoptions" = {
    # Ensures the service waits for the VPN during the boot sequence
    after = [ "wg-quick-mullvad.service" ];
    
    # TODO figure out how to handle display not being :0 
    script = ''
      # Waits 10 seconds before checking
      sleep 10
      
      # Exit gracefully if the Mullvad WireGuard service is not active
      if ! systemctl is-active --quiet wg-quick-mullvad.service; then
        exit 0
      fi
      
      # Only launch if mullvad-browser is not already running
      if ! ${pkgs.procps}/bin/pgrep -f "mullvad-browser" > /dev/null; then
        DISPLAY=:0 ${lib.getExe pkgs.mullvad-browser} https://search.nixos.org/options
      fi
    '';
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "${config.users.users.nyx.name}";
    };
  };

  systemd.timers."nixosoptions" = {
    wantedBy = [ "timers.target" ]; 
    timerConfig = {
      # Triggers the timer 10 seconds after system boot
      OnBootSec = "10s";
      
      # Optional: Uncomment if you want it to repeat every 10 seconds
      # OnUnitActiveSec = "10s"; 
      
      Persistent = true;
    };
  };
}