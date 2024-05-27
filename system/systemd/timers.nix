# systemd alternative to crontab
# https://wiki.archlinux.org/title/Systemd/Timers
{ config, pkgs, ... }:
# systemctl list-timers --all

{
  # l $(which nix-store)
  # test with sudo systemctl status repair.service
  systemd.services."repair" = {
    script = ''
      ${pkgs.nix}/bin/nix-store --repair --verify --check-contents
    '';
    serviceConfig = {
      # Type = "oneshot";
      User = "root";
    };
  };
  systemd.timers."repair" = {
    wantedBy = [ "timers.target" ]; 
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };
}