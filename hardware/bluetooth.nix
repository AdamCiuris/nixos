{ config, pkgs, ... }:
{
#  This will disable bluetooth on boot and remove the bluetooth package from the system. 
  services.blueman.enable = false; # disable blueman
	hardware = {
    bluetooth.enable = false;
    bluetooth.package = null; # disable bluetooth
    bluetooth.powerOnBoot = false;
  };
} 