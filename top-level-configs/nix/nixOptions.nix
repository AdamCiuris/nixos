{ configs, pkgs, ... }: {
  nix.gc.automatic = true;
	nix.gc.options = "--delete-older-than 5d";
	nix.settings.experimental-features = ["nix-command" "flakes"]; # needed to try flakes from tutorial
	nix.nixPath = [ # echo $NIX_PATH
		"nixpkgs=/home/nyx/.nix-defexpr/channels/nixpkgs"
		"nixos-config=/etc/nixos/top-level-config/configuration.nix"
	];
}