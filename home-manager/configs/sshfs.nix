{ pkgs, ... }:

{
  home.packages = [ pkgs.sshfs ];

  # systemd.user.services.mount-vrchat-caches = {
  #   Unit = {
  #     Description = "Mount VRChat Caches via SSHFS over Tailscale";
  #     After = [ "network-online.target" ];
  #   };
  #   Install = {
  #     WantedBy = [ "default.target" ];
  #   };
  #   Service = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #     # Replace 'user@laptop-ip' and '/home/user/' with your actual laptop Tailscale credentials
  #     ExecStart = [
  #       "${pkgs.sshfs}/bin/sshfs user@laptop-ip:/home/user/vrchat-laptop-cache/Cache-WindowsPlayer %h/.steam/steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/AppData/LocalLow/VRChat/VRChat/Cache-WindowsPlayer -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3"
  #       "${pkgs.sshfs}/bin/sshfs user@laptop-ip:/home/user/vrchat-laptop-cache/HTTPCache %h/.steam/steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/AppData/LocalLow/VRChat/VRChat/HTTPCache -o reconnect,ServerAliveInterval=15,ServerAliveCountMax=3"
  #     ];
  #     ExecStop = [
  #       "fusermount -u %h/.steam/steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/AppData/LocalLow/VRChat/VRChat/Cache-WindowsPlayer"
  #       "fusermount -u %h/.steam/steam/steamapps/compatdata/438100/pfx/drive_c/users/steamuser/AppData/LocalLow/VRChat/VRChat/HTTPCache"
  #     ];
  #   };
  # };
}