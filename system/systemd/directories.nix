{ config, pkgs, lib, ... }:
{
  systemd.tmpfiles.settings = {
    "nottemp"={
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

    } // lib.attrsets.genAttrs ((builtins.map (x: "/home/"+x+"/GITHUB")) (builtins.attrNames  config.home-manager.users)) (name: {d={mode="0755"; user=builtins.elemAt (lib.strings.split "/" name) 4 ; group="users";};});
    # above generates a bunch of directories for each user in home-manager.users
    # (builtins.attrNames  config.home-manager.users) gets the list of users
    # lib.attrsets.genAttrs ((builtins.map (x: "/home/"+x+"/GITHUB")) makes attributes for each username as name (name: {d={mode="0755"; user=builtins.elemAt (lib.strings.split "/" name) 4 ; group="users";};})
};
}
# <filesystem type="mount" accessmode="passthrough">
#   <source dir="/home/nyx/share"/>
#   <target dir="share"/>
#   <alias name="fs0"/>
#   <address type="pci" domain="0x0000" bus="0x07" slot="0x00" function="0x0"/>
# </filesystem>
