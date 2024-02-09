{  pkgs,... }:
let
	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
	
	imports = [
		(import "${home-manager}/nixos")
	];
	users.users.nyx.isNormalUser = true;
	home-manager.users.nyx = {

		programs.git = {
			enable = true;
			userName = "Adam Ciuris";
			userEmail = "adamciuris@gmail.com";
		};

		programs.bash.enable=true;
		home.stateVersion = "23.11";
		# programs.home-manager.enable=true;
		home.packages = with pkgs; [
			htop
			git
			geckodriver #firefox selenium
			python313
			python311Packages.pip
			vscode
			wget
		];
		nixpkgs.config.allowUnfree=true;

		# begin user configs
		programs.vscode = {

		enable=true;
			userSettings  = {
				"files.autoSave" = "afterDelay";
				"files.autoSaveDelay" = 0;
				"window.zoomLevel"= -1;
				"workbench.colorTheme"= "Tomorrow Night Blue";
			};
			keybindings =  [
				{
					key="ctrl+shift+[";
					command= "workbench.debug.action.focusRepl";
				}
				{
					key="ctrl+shift+]";
					command= "workbench.action.terminal.focus";
				}
				{
					key = "alt+q";
					command = "editor.action.deleteLines";
				}
			];
		};
	};

}	
