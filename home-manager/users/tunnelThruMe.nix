{ inputs, outputs, lib, config, pkgs, ... }:
{
	home ={
		username = "tunnelThruMe";
		homeDirectory = "/home/tunnelThruMe";
		# You should not change this value, even if you update Home Manager. If you do
		# want to update the value, then make sure to first check the Home Manager
		# release notes.
		stateVersion = "24.05";
		
	};

	home.file = {
	};

	home.sessionVariables = {
		EDITOR = "nano";
	};

	# if not nixOS chsh to /usr/bin/zsh else change users.defaultShell
		nixpkgs.config.allowUnfree=true;
		fonts.fontconfig.enable = true;
		home.packages = with pkgs; [
			libreoffice
			htop
			git
			gimp
			vlc
			zsh
			xdg-utils
			brave

			# x2g0
			(pkgs.nerdfonts.override { fonts=["DroidSansMono" ]; }) # for vscode
			];



  imports = [
		../configs/git.nix
		../configs/xdg.nix
		../configs/vscodium.nix
		../configs/shells.nix
		../configs/plasma.nix
		../../system/programs/msmtp.nix
  ];


}
