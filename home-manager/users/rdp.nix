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
		../configs/thunderbird.nix
		../configs/ssh.nix
    
	];
	home ={
		username = "rdp";
		homeDirectory = "/home/rdp";
		stateVersion = "24.11";
	};


}
