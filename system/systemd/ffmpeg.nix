{ config, lib, pkgs, ... }:

{
  systemd.user.services.audio-recorder = {
    description = "Hourly PipeWire Audio Recorder";
    after = [ "pipewire.service" "wireplumber.service" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "simple";
      # 1. Re-enable this: FFmpeg will crash if the folder doesn't exist.
      # %h is the systemd shortcut for your home directory.
      # user = "root";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /recordings";
      
      ExecStart = ''
        ${pkgs.ffmpeg}/bin/ffmpeg \
          -f pulse -i default \
          -f pulse -i @DEFAULT_MONITOR@ \
          -filter_complex "amix=inputs=2" \
          -f segment \
          -segment_time 3600 \
          -reset_timestamps 1 \
          -strftime 1 \
          "/recordings/rec_%%Y-%%m-%%d_%%H-%%M-%%S.mp3"
      '';
      Restart = "always";
      RestartSec = "5s";
    };
  };

  environment.systemPackages = [ pkgs.ffmpeg ];
}