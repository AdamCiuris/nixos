{ config, pkgs, ... }: {
  systemd.services.sync-pictures = {
    description = "Rsync local Pictures to nyx-asus-laptop over Tailscale";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    # This exposes the `ssh` binary to the service environment
    path = [ pkgs.openssh ]; 
    
    serviceConfig = {
      Type = "oneshot";
      User = "${config.users.users.nyx.name}";
      ExecStart = "${pkgs.rsync}/bin/rsync -avz /home/nyx/Pictures/ nyx-asus-laptop:~/Pictures/";
      Environment = "RSYNC_RSH=ssh -o ConnectTimeout=10";
    };
  };

  systemd.timers.sync-pictures = {
    description = "Timer to rsync Pictures to Asus laptop 30 mins after boot";
    wantedBy = [ "timers.target" ];
    
    timerConfig = {
      OnBootSec = "30min";
    };
  };
}