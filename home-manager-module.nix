{ pkgs,... }:
let
	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
	imports = [
		(import "${home-manager}/nixos")
	];

	home-manager.users.nyx = {

		programs.git = {
			enable = true;
			userName = "Adam Ciuris";
			userEmail = "adamciuris@gmail.com";
		};


		home.stateVersion = "18.09";
		programs.home-manager.enable=true;
		home.packages = with pkgs; [
			htop
			git
			geckodriver #firefox selenium
			python313
			python311Packages.pip
			vscode
			wget
		];

		# begin user configs
		programs.vscode.userSettings  = {
	
			"files.autoSave" = "afterDelay";
			"files.autoSaveDelay" = "20";
			"window.zoomLevel"= "-1";
			"workbench.colorTheme"= "Red";
		};
		programs.vscode.keybindings = {
			key= "ctrl+shift+[";
			command = "Debug: Select Debug Console";

		};
	};

}	
