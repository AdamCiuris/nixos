{ ... }:

let
	nix-alien-pkgs = import (
		builtins.fetchTarball "https://github.com/nix-community/nix-index/tarball/master"
	) { };
in
{
	environment.systemPackages = with nix-index-pkgs; [
		nix-index
	];

	# Optional, but this is needed for `nix-alien-ld` command
	programs.nix-ld.enable = true;
}
