({ lib, config, pkgs, ... }: 
{
	config = lib.mkIf (config.specialisation != {}) {
		services.xserver.displayManager.lightdm.enable = true; 
		services.xserver.desktopManager.cinnamon.enable = true;
		services.xserver.desktopManager.wallpaper.mode = "centered";
	};
})