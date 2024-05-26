{ config, pkgs, ... }: 
{
	# Enable the X11 windowing system.
	services.xserver = {
		enable = true;
    libinput.enable = true; 	# Enable touchpad support (enabled default in most desktopManager).
    displayManager.autoLogin.user = null; # don't set
		displayManager.autoLogin.enable = false; # do not autologin
    layout = "us";
		xkbVariant = "";
	};
}