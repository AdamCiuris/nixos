{ config, lib, pkgs, ... }: 
{
	# ystemctl --user restart pipewire-pulse wireplumber pipewire
	environment.systemPackages = with pkgs; [ 
      ffmpeg # standard audio/video tool
      # alsa-utils # arecord
      # pulseaudio # Provides pactl
    ];
    
}