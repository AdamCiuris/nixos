{ config, pkgs, ... }: 
{
	# Enable the X11 windowing system.
	services.libinput.enable = true; 	# Enable touchpad support (enabled default in most desktopManager).
  services.displayManager.autoLogin.user = null; # don't set
	services.xserver = {
		enable = true;
		displayManager.autoLogin.enable = false; # do not autologin
    xkb.layout = "us";
		xkb.variant = "";
	};
}