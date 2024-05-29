# systemd alternative to crontab
# https://wiki.archlinux.org/title/Systemd/Timers
{ config, pkgs, lib, ... }:
# systemctl list-timers --all

{
  # l $(which nix-store)
  # test with sudo systemctl status repair.service
  systemd.services."gunicorn" = {
    description = "gunicorn daemon";
    requires = [ "gunicorn.socket" ];
    after = [ "network.target" ];
    serviceConfig = {
      # Type = "oneshot";
      User = "${config.users.users.nyx.name}";
      Group = "www-data";
      WorkingDirectory = "/home/nyx/GITHUB/portfolio-website/";
      ExecStart=''${(pkgs.python3.withPackages (python-pkgs: [
        python-pkgs.ipython
        python-pkgs.gunicorn
        python-pkgs.django
        python-pkgs.pandas
        python-pkgs.numpy
		]))}/bin/gunicorn  \
            --workers 3 \
            --bind unix:/run/gunicorn.sock
             portfolio.wsgi:application'';
    };
  };
  systemd.sockets."gunicorn" = {
    description = "gunicorn socket";
    wantedBy = [ "sockets.target" ];
    socketConfig = {
      # ListenStream = "${config.services.gunicorn.socket}";
      ListenStream = "/run/gunicorn.sock";
    };
  };
}