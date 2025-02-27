{	config,lib, pkgs,... }:
let 
	 filterAttrSet = attrSet: pattern:
    lib.attrsets.filterAttrs (name: value: builtins.match pattern value != null ) attrSet; # filter attrs based on a pattern that matches values to pattern
	grimoire = map (a: ../../. +  builtins.toPath "/grimoire/${a}" )  # create absolute path for those files in grimoire that match "*thoron.nix"
		(builtins.filter # filter out all files that dont match "*thoron.nix"
			(a: builtins.match  ".*thoron\\.nix" a != null) # match files in readDir that match "*thoron.nix" (the would be null if they didnt match)
				(builtins.attrNames # get filenames
					(filterAttrSet (builtins.readDir ../../grimoire)  "regular") # find all files in readDir that match "regular", so just all regular files
				)
		);
in 
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
		username = "nyx";
		homeDirectory = "/home/nyx";
		stateVersion = "24.11";
	};
	home.file = { # starts at ~/.config
		# ".config/autostart/virt-manager.desktop".source = "${pkgs.virt-manager}/share/applications/virt-manager.desktop";
		# horrible startup javascript apps
		".config/autostart/brave-browser.desktop".source = "${pkgs.brave}/share/applications/brave-browser.desktop";
		# ".config/autostart/firefox.desktop".source = "${pkgs.firefox}/share/applications/firefox.desktop";
		# ".config/autostart/codium.desktop".source = "${pkgs.vscode}/share/applications/codium.desktop";# TODO figure out how to git pkgs.vscodium or pkgs.vscode to point to right place
		# ".config/autostart/thunderbird.desktop".source = "${pkgs.thunderbird}/share/applications/thunderbird.desktop";
	};
	home.packages = with pkgs; [
		protonup # steam compatibility tools, must be run imperatively with `protonup` in cmd prompt
		wireshark # packet sniffer
		gnupg # gpg
		yt-dlp # youtube-dl fork
	];
	home.sessionVariables = {
		STEAM_EXTRA_COMPAT_TOOLS_PATHS = 
			"\${HOME}/.steam/root/compatibilitytools.d";
	};



}
