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

		programs.bash ={
			enable=true;
			historyControl = ["ignoredups"];
			shellAliases =  { src = "source"; "..." = "../../"; nrs = "sudo nixos-rebuild switch"; 
								"g*" = "git add *"; "gcm" = "git commit -m";
								gp = "git push"; # conflicts with global-platform-pro, pari
								resrc= "source ~/.bashrc";
								};

			initExtra = ''
			pvenv() {
				# starts a python virtual environment named after first arg and if a path to a requirements file is provided as second arg it installs it
				# "deactivate" leaves the venv
				local firstArg="$1"
				local activate="./$firstArg/bin/activate"
				python -m venv $firstArg && source $activate
				if [ ! -z "$2" ]; then
					pip install $2
				fi
			}
			'';
		};
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
			mutableExtensionsDir = false; # stops vscode from editing ~/.vscode/extensions/* which makes the following extensions actually install
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
					name = "Nix";
					publisher = "bbenoist"; # https://marketplace.visualstudio.com/items?itemName=bbenoist.Nix
					version = "1.0.1";
					sha256 ="sha256-qwxqOGublQeVP2qrLF94ndX/Be9oZOn+ZMCFX1yyoH0="; # to find sha just run without and steal from error message
				}
			];
		};
	};

}	
