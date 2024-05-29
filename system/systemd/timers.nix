# systemd alternative to crontab
# https://wiki.archlinux.org/title/Systemd/Timers
{ config, pkgs, lib, ... }:
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
      User = "${config.users.users.root.name}";
    };
  };
  systemd.timers."repair" = {
    wantedBy = [ "timers.target" ]; 
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

    # test with sudo systemctl status randomize.service
  systemd.services."randomize" = {
    script = ''
      ${lib.getExe (pkgs.python3.withPackages (python-pkgs: [
			python-pkgs.pandas
			python-pkgs.numpy
		]))} ${config.users.users.nyx.home}/Downloads/randumb/randomize.py
    '';
    serviceConfig = {
      # Type = "oneshot";
      User = "${config.users.users.nyx.name}";
    };
  };
  systemd.timers."randomize" = {
    wantedBy = [ "timers.target" ]; 
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}