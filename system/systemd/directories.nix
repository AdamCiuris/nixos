{ config, pkgs, ... }:
{
  systemd.tmpfiles.settings = {
    "test"={
      "/etc/nginx/sites-available" = {
          d = { # TODO symlink nginx stuff here so tutorials easier
            # description = "Create /etc/nginx/sites-available with correct permissions";
            mode = "0700"; # root only rwx
            user = "root";
            group = "root";
        };
      };
      "/etc/msmtp" = {
          d = {
            mode = "0700"; # root only rwx
            user = "root";
            group = "root";
          };
    };
  };
  };
}