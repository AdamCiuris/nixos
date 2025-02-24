# systemd alternative to crontab
# https://wiki.archlinux.org/title/Systemd/Timers
{ config, pkgs, lib, ... }:
# systemctl list-timers --all

{
  environment.systemPackages = with pkgs; [
    mullvad-browser
  ];
  systemd.services."nixosoptions" = {
    # TODO figure out how to handle display not being :0 
    script = ''
     DISPLAY=:0 ${lib.getExe pkgs.mullvad-browser} https://search.nixos.org/options
    '';
    # after = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      # Type = "oneshot";
      User = "${config.users.users.nyx.name}";

    };
  };
    systemd.timers."nixosoptions" = {
    wantedBy = [ "timers.target" ]; 
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}