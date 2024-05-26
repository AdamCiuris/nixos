{ config, pkgs, ... }: 
{
  specialisation = { # Let's you pick the desktop manager in grub
		cinnaminmin = { configuration={
			services.xserver.displayManager.lightdm.enable = true; 
			services.xserver.desktopManager.cinnamon.enable = true;
		};};
		MATE = { configuration={
			services.xserver.displayManager.lightdm.enable = true; 
			services.xserver.desktopManager.mate.enable = true;
		};};
		common = { configuration={
			services.xserver.displayManager.lightdm.enable = true; 
			services.xserver.desktopManager.cde.enable = true;
		};};
		budgie = { configuration={
			services.xserver.displayManager.lightdm.enable = true; 
			services.xserver.desktopManager.budgie.enable = true;
		};};
		KDE = { configuration={
			services.xserver.displayManager.sddm.enable = true;
			services.xserver.desktopManager.plasma5.enable = true;
		};};
		GNOME = { configuration={
			services.xserver.displayManager.gdm.enable = true;
			services.xserver.desktopManager.gnome.enable = true;
		};};
	};
}