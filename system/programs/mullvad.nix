{ config, lib, pkgs, ...}:{

	services.mullvad-vpn.enable = true;
	services.mullvad-vpn.package = pkgs.mullvad-vpn;
	
	environment.systemPackages = with pkgs; [
		mullvad
		(pkgs.makeAutostartItem {
      name = "mullvad-vpn";
      package = pkgs.mullvad-vpn;
    })
	];
}