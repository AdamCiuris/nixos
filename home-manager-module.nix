{  pkgs,... }:
let
	home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
	
	imports = [
		(import "${home-manager}/nixos")
	];
	users.users.nyx.isNormalUser = true; # I'm a normal guy
	home-manager.users.nyx = {


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
		programs.git = {
			enable = true;
			userName = "Adam Ciuris";
			userEmail = "adamciuris@gmail.com";
		};

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
			# installing malware
			extensions = with pkgs.vscode-extensions; [
				ms-vscode-remote.remote-containers # for when flakes are too annoying
				ms-azuretools.vscode-docker
				batisteo.vscode-django
				ms-python.vscode-pylance
				ms-python.python
				shd101wyy.markdown-preview-enhanced
			]++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
				{
					name = "Nix"; # testing if this works better (it doesn't)
					publisher = "bbenoist";
					version = "1.0.1";
					sha256 ="sha256-qwxqOGublQeVP2qrLF94ndX/Be9oZOn+ZMCFX1yyoH0="; # to find sha just run without and steal from error message
				}
			];
		};
	};

}	
