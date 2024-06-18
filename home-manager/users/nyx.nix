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
    
	];
	home ={
		username = "nyx";
		homeDirectory = "/home/nyx";
		stateVersion = "24.05";
	};
	home.file = { # starts at ~/.config
		".config/autostart/virt-manager.desktop".source = "${pkgs.virt-manager}/share/applications/virt-manager.desktop";
		# horrible startup javascript apps
		".config/autostart/brave-browser.desktop".source = "${pkgs.brave}/share/applications/brave-browser.desktop";
		".config/autostart/firefox.desktop".source = "${pkgs.firefox}/share/applications/firefox.desktop";
		# ".config/autostart/codium.desktop".source = "${pkgs.vscode}/share/applications/codium.desktop";# TODO figure out how to git pkgs.vscodium or pkgs.vscode to point to right place
		".config/autostart/thunderbird.desktop".source = "${pkgs.thunderbird}/share/applications/thunderbird.desktop";
	};
	home.packages = with pkgs; [
		protonup # steam compatibility tools, must be run imperatively with `protonup` in cmd prompt
		wireshark # packet sniffer
		gnupg # gpg
	];
	home.sessionVariables = {
		STEAM_EXTRA_COMPAT_TOOLS_PATHS = 
			"\${HOME}/.steam/root/compatibilitytools.d";
	};
	programs.ssh = { 
		enable = true;
		matchBlocks."github.com" = {
					hostname = "github.com";
					identityFile = "~/.ssh/id_ed25519_github";
		};
	};


}
