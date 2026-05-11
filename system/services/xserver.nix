{ config, pkgs, ... }: 
{
	# Enable the X11 windowing system.
	services.libinput.enable = true; 	# Enable touchpad support (enabled default in most desktopManager).
  services.displayManager.autoLogin.user = null; # don't set
  services.displayManager.autoLogin.enable = false; # do not autologin
	services.xserver = {
		enable = true;
    	xkb.layout = "us,ru,jp,il,ua,latam,ara"; # /run/current-sysem/sw/share/X11/xkb/rules/base.lst
		xkb.variant = "";
		xkb.options = "grp:ctrl_alt_toggle";
	};
}