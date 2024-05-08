{ config, pkgs, ... }: {
	services.nextcloud = {
		enable = false;
		package = pkgs.nextcloud;
	};
}