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
      "${config.users.users.nyx.home}/share" = { # sudo mount -t 9p -o trans=virtio share /mnt/    
          d = { 
            mode = "0755"; 
            user = "nyx";
            group = "users";
          };
    };
# <filesystem type="mount" accessmode="passthrough">
#   <source dir="/home/nyx/share"/>
#   <target dir="share"/>
#   <alias name="fs0"/>
#   <address type="pci" domain="0x0000" bus="0x07" slot="0x00" function="0x0"/>
# </filesystem>

  };
  };
}