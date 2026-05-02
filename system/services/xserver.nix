{ config, pkgs, ... }: 
{
	# Enable the X11 windowing system.
	services.libinput.enable = true; 	# Enable touchpad support (enabled default in most desktopManager).
  services.displayManager.autoLogin.user = null; # don't set
  services.displayManager.autoLogin.enable = false; # do not autologin
	services.xserver = {
		enable = true;
    xkb.layout = "us";
		xkb.variant = "";
	};
}