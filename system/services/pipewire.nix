{ config, lib, pkgs, ... }: 
{
  hardware.pulseaudio = {
    enable = false;
  }; # Using PipeWire as the sound server conflicts with PulseAudio. This option requires `hardware.pulseaudio.enable` to be set to false
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};
}