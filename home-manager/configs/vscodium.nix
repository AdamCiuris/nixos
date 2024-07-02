{ config, pkgs, ...}:
let 
	ext =  name: publisher: version: sha256: pkgs.vscode-utils.buildVscodeMarketplaceExtension {
	mktplcRef = { inherit name publisher version sha256 ; };
	};
in
{
	programs.vscode = {
		package=pkgs.vscodium;
		enable=true;
		userSettings  = {
			"files.autoSave" = "afterDelay";
			"files.autoSaveDelay" = 0;
			"window.zoomLevel"= -1;
			"files.exclude" = ""; # stop excluding files please
			"workbench.colorTheme"= "Tomorrow Night Blue";
			"editor.multiCursorModifier" = "ctrlCmd"; # ctrl + click for multi cursor
			"terminal.integrated.fontFamily" = "DroidSansM Nerd Font"; # fc-list to see all fonts
		};
		keybindings =  [
			{
			key= "alt+p";
			command = "workbench.action.terminal.focusNext";
			}
			{
			key= "alt+o";
			command = "workbench.action.terminal.focusPrevious";
			}
			{
				key = "alt+a";
				command = "editor.action.copyLinesDownAction";
			}
			{
				key = "alt+z";
				command = "editor.action.copyLinesUpAction";
			}
			{
				key =  "ctrl+shift+tab";
				command =  "workbench.action.previousEditor";
			}
			{
				key = "ctrl+tab";
				command = "workbench.action.nextEditor";
			}
			{
				key = "ctrl+f8";
				command = "editor.action.marker.next";
			}
			{
				key="ctrl+shift+[";
				command= "workbench.debug.action.focusRepl";
			}
			{
				key="ctrl+shift+]";
				command= "workbench.action.terminal.focus";
			}
			{
				key = "alt+d";
				command = "editor.action.deleteLines";
			}
			{
				key = "ctrl+shift+1";
				command = "workbench.action.terminal.resizePaneUp";
				when = "terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported";
			}
			{
				key = "ctrl+shift+2";
				command = "workbench.action.terminal.resizePaneDown";
				when = "terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported";
			}
			{
				key = "ctrl+alt+m";
				command = "markdown.showLockedPreviewToSide";
			}
		];
		mutableExtensionsDir = false; # stops vscode from editing ~/.vscode/extensions/* which makes the following extensions actually install
		# installing malware

		extensions = (with pkgs.vscode-extensions; [
			ms-python.vscode-pylance
			ms-vscode-remote.remote-containers
			ms-vscode-remote.remote-ssh
			ms-azuretools.vscode-docker
			batisteo.vscode-django
			ms-python.python
			mkhl.direnv
			shd101wyy.markdown-preview-enhanced
			ms-toolsai.jupyter
			
		]) ++ [ #  "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
			(ext "Nix" "bbenoist" "1.0.1" "sha256-qwxqOGublQeVP2qrLF94ndX/Be9oZOn+ZMCFX1yyoH0=") # https://marketplace.visualstudio.com/items?itemName=bbenoist.Nix
			(ext "copilot" "GitHub"  "1.208.963" "sha256-KK+jscoH/tByYw5BL2c5xEbqErnJE30enTqHWJzhIQk=") # https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
			(ext "remote-server" "ms-vscode"  "1.6.2024061709" "sha256-OaLCYdAqPRppxu4bNOig87bwi0brhAW91I22IBUWjhA=") # https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
			# (ext "copilot" "GitHub"  "1.197.0" "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=") # https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
			# (ext "copilot" "GitHub"  "1.197.0" "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=") # https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
			(ext  "bash-debug" "rogalmic" "0.3.9" "sha256-f8FUZCvz/PonqQP9RCNbyQLZPnN5Oce0Eezm/hD19Fg=") # https://marketplace.visualstudio.com/items?itemName=rogalmic.bash-debug
			(ext "nix-ide" "jnoortheen" "0.3.1" "sha256-jwOM+6LnHyCkvhOTVSTUZvgx77jAg6hFCCpBqY8AxIg=" ) # https://marketplace.visualstudio.com/items?itemName=jnoortheen.nix-ide
		];
	}; # END VSCODE
}