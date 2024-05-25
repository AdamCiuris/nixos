{ config, pkgs, ... }:
{
    boot.loader = {
		systemd-boot.enable = true;
		efi.canTouchEfiVariables = true;
		efi.efiSysMountPoint = "/boot";
		#grub = {
		#	enable = true;
		#	efiSupport = true;
		#	useOSProber = true;
		#	splashImage = null;
		# devices = [ "nodev" ];
		#};
	};
}