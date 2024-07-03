{	config,lib, pkgs,... }:
{
	imports = [
    ../home.nix

		../configs/brave.nix
		../configs/fiyafox.nix
		../configs/dconf.nix
		../configs/shells.nix
		../configs/git.nix
		../configs/vscode.nix
		../configs/xdg.nix
    
	];
	home ={
		username = "bael";
		homeDirectory = "/home/bael";
		stateVersion = "24.05";
	};
	home.file = { # starts at ~/.config
		".config/autostart/brave-browser.desktop".source = "${pkgs.brave}/share/applications/brave-browser.desktop";
		".config/autostart/firefox.desktop".source = "${pkgs.firefox}/share/applications/firefox.desktop";
	};
	home.packages = with pkgs; [
		gnupg # gpg
	];
	programs.ssh = { 
		enable = true;
		matchBlocks."github.com" = {
				hostname = "github.com";
				identityFile = "~/.ssh/id_ed25519_github";
		};
		matchBlocks."gcloud_local" = {
				hostname = "10.0.0.187"; # subject to change TODO find out some way to imperatively set this or change accordingly
				user = "nyx";
				# localForwards = [
				# 	{
				# 	# bind.port = 22;
				# 	host.address = "10.0.0.187";
				# 	# bind.port = 22;
				# 	}
				# ];
				identityFile = "~/.ssh/server_ided.pub ";		
		};
	};


}
