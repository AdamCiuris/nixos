{	config,lib, pkgs,... }:
{
	imports = [
		../home.nix

		../configs/brave.nix
		../configs/fiyafox.nix
		../configs/dconf.nix
		../configs/shells.nix
		../configs/xdg.nix
    ../configs/plasma.nix
	];
	home ={
		username = "chi";
		homeDirectory = "/home/chi";
		stateVersion = "24.05";
	};


}
