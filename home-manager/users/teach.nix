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
		username = "teach";
		homeDirectory = "/home/teach";
		stateVersion = "23.11";
	};


}
