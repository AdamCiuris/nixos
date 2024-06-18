{	config,lib, pkgs,... }:
{
	imports = [
    ../home.nix

		../configs/brave.nix
		../configs/fiyafox.nix
		../configs/dconf.nix
		../configs/shells.nix
		../configs/git.nix
		../configs/vscodium.nix
		../configs/xdg.nix
    
	];
	home ={
		username = "rdp";
		homeDirectory = "/home/rdp";
		stateVersion = "24.05";
	};


}
