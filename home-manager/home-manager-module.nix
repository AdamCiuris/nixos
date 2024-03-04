{  pkgs,... }:
let
	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";

in
{
	imports =  [
		(import "${home-manager}/nixos")
	];
	users.defaultUserShell = pkgs.zsh;
	# BEGIN USER NYX
	users.users.nyx.isNormalUser = true; # I'm a normal guy
	users.users.nyx.useDefaultShell = true; # should be zsh
	home-manager.users.nyx = {
		imports = [./home.nix];
	}; # END USER NYX 
}
