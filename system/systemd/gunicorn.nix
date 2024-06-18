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
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      # Type = "oneshot";
      User = "${config.users.users.nyx.name}";
      # Group = "www-data";
      WorkingDirectory = "/home/nyx/GITHUB/portfolio-website/";
      ExecStart=''${(pkgs.python3.withPackages (python-pkgs: [
        python-pkgs.ipython
        python-pkgs.gunicorn
        python-pkgs.django
        python-pkgs.pandas
        python-pkgs.numpy
		]))}/bin/gunicorn  \
            --access-logfile - \
            --workers 3 \
            --bind unix:/run/gunicorn.sock \
             personal_portfolio.wsgi:application''; # name of the wsgi file in module personal_portfolio within working directory
    };
  };
  systemd.sockets."gunicorn" = {
    description = "gunicorn socket";
    wantedBy =  ["sockets.target"]; # don't need to sysctl enable with this, https://search.nixos.org/options?channel=24.05&show=systemd.sockets.%3Cname%3E.wantedBy&from=0&size=50&sort=relevance&type=packages&query=systemd.sockets.%3Cname%3E.
    socketConfig = {
      # ListenStream = "${config.services.gunicorn.socket}";
      ListenStream = "/run/gunicorn.sock";
    };
  };
}