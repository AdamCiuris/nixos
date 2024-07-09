{ config, pkgs, ... }: 
{
	services.nextcloud = {
		enable = true;
		package = pkgs.nextcloud;
	};
}