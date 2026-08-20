{ config, lib, pkgs, ... }:

let
  motionConf = pkgs.writeText "motion.conf" ''
    # --- Camera Input Settings ---
    videodevice /dev/video0
    width 1280
    height 720
    framerate 15

    # --- Motion Detection ---
    threshold 1500
    pre_capture 3
    post_capture 5

    # --- Recording Output ---
    picture_output off
    movie_output on
    movie_max_time 60
    target_dir /var/lib/motion
    movie_filename motion-%Y%m%d-%H%M%S

    # --- Web Stream ---
    stream_port 8081
    stream_localhost off
  '';
in
{
  # Install the motion package
  environment.systemPackages = [ pkgs.motion ];

  # Create a dedicated system user and group
  users.groups.motion = {};
  users.users.motion = {
    isSystemUser = true;
    group = "motion";
    extraGroups = [ "video" ]; # Required to access /dev/video*
  };

  # Automatically create the recording directory with correct permissions
  systemd.tmpfiles.rules = [
    "d /var/lib/motion 0750 motion motion -"
  ];

  # Define the systemd service to run the motion package
  systemd.services.motion = {
    description = "Motion detection camera daemon";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      User = "motion";
      Group = "motion";
      # -n runs in foreground, -c specifies the config file path
      ExecStart = "${pkgs.motion}/bin/motion -n -c ${motionConf}";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };

  # Allow stream access strictly over Tailscale
  networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 8081 ];
}
