{	config,lib, pkgs,... }:
{
	imports = [
		../home.nix

		../configs/opera.nix
		../configs/dconf.nix
		../configs/shells.nix
		../configs/vscodium.nix
		# ../configs/.secret.nix
	];
	home ={
		username = "lock";
		homeDirectory = "/home/lock";
		stateVersion = "24.11";
	};
	home.file = { # starts at ~/.config
		# horrible startup javascript apps
		".config/autostart/opera.desktop".source = "${pkgs.opera}/share/applications/opera.desktop";
		".config/autostart/thunderbird.desktop".source = "${pkgs.thunderbird}/share/applications/thunderbird.desktop";
	};

}
