{ config, pkgs, ...}:
let 
	ext =  name: publisher: version: sha256: pkgs.vscode-utils.buildVscodeMarketplaceExtension {
	mktplcRef = { inherit name publisher version sha256 ; };
	};
in
{
	programs.vscode = {
		enable=true;
		userSettings  = {
			"files.autoSave" = "afterDelay";
			"files.autoSaveDelay" = 0;
			"window.zoomLevel"= -1;
			"workbench.colorTheme"= "Tomorrow Night Blue";
			"terminal.integrated.fontFamily" = "DroidSansM Nerd Font"; # fc-list to see all fonts
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
				key = "alt+d";
				command = "editor.action.deleteLines";
			}
			{
				key = "shift+alt+2";
				command = "workbench.action.terminal.resizePaneUp";
				when = "terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported";
			}
			{
				key = "shift+alt+1";
				command = "workbench.action.terminal.resizePaneDown";
				when = "terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported";
			}
		];
		mutableExtensionsDir = false; # stops vscode from editing ~/.vscode/extensions/* which makes the following extensions actually install
		# installing malware

		extensions = (with pkgs.vscode-extensions; [
			ms-vscode-remote.remote-containers # for when flakes are too annoying
			ms-azuretools.vscode-docker
			batisteo.vscode-django
			ms-python.vscode-pylance
			ms-python.python
			shd101wyy.markdown-preview-enhanced
			ms-toolsai.jupyter
		]) ++ [
			(ext "Nix" "bbenoist" "1.0.1" "sha256-qwxqOGublQeVP2qrLF94ndX/Be9oZOn+ZMCFX1yyoH0=") # https://marketplace.visualstudio.com/items?itemName=bbenoist.Nix
			(ext "copilot" "GitHub"  "1.168.0" "sha256-KoN3elEi8DnF1uIXPi6UbLh+8MCSovXmBFlvJuwAOQg=") # https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
			(ext "nix-ide" "jnoortheen" "0.2.2" "sha256-jwOM+6LnHyCkvhOTVSTUZvgx77jAg6hFCCpBqY8AxIg=" ) # https://marketplace.visualstudio.com/items?itemName=jnoortheen.nix-ide
		];
	}; # END VSCODE
}