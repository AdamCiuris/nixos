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

  # test with sudo systemctl status nyx_backup.service
  # https://help.ubuntu.com/community/BackupYourSystem/TAR
  systemd.services."nyx_backup" = {
    path= [ pkgs.gnutar 
      pkgs.gzip
    ];
    script = ''

      ${lib.getExe  pkgs.gnutar} -cvpzf nyx_home_backup.tar.gz --exclude=${config.users.users.nyx.home}/.local --exclude=${config.users.users.nyx.home}/share --exclude=${config.users.users.nyx.home}/GITHUB --one-file-system ${config.users.users.nyx.home} 
    '';
    serviceConfig = {
      # Type = "oneshot";
      User = "${config.users.users.root.name}";
    };
  };
  systemd.timers."nyx_backup" = {
    wantedBy = [ "timers.target" ]; 
    timerConfig = {
      OnCalendar = "weekly";
      Persistent = true;
    };
  };
}