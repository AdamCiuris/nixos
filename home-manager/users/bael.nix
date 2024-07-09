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
		../configs/ssh.nix
    
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


}
