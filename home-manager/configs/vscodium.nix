{ config, pkgs, pkgs-unstable, ...}:
let 
	ext =  name: publisher: version: sha256: pkgs.vscode-utils.buildVscodeMarketplaceExtension {
	mktplcRef = { inherit name publisher version sha256 ; };
	};
in
{
	programs.vscode = {
		package=pkgs-unstable.vscodium;
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
				key = "alt+q";
				command = "workbench.action.terminal.kill";
				when = "terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported";
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
			# BEGIN COPILOT SHORTCUTS
			{
				key = "ctrl+/";
				command = "github.copilot.acceptCursorPanelSolution";
				when = "github.copilot.activated && github.copilot.panelVisible && activeWebviewPanelId == 'GitHub Copilot Suggestions'";
			}
			{
				
				key = "alt+]";
				command = "github.copilot.nextPanelSolution";
				when = "github.copilot.activated && github.copilot.panelVisible && activeWebviewPanelId == 'GitHub Copilot Suggestions'";
			}
			{
				key = "alt+[";
				command = "github.copilot.previousPanelSolution";
				when = "github.copilot.activated && github.copilot.panelVisible && activeWebviewPanelId == 'GitHub Copilot Suggestions'";
			}
			{
				key = "ctrl+enter";
				command = "github.copilot.generate";
				when = "editorTextFocus && github.copilot.activated && !commentEditorFocused && !inInteractiveInput && !interactiveEditorFocused";
			}
			{
				key = "ctrl+super+c";
				command = "editor.action.inlineSuggest.trigger";
				when = "config.github.copilot.inlineSuggest.enable && editorTextFocus && !editorHasSelection && !inlineSuggestionsVisible";
			}
			{
			key =  "ctrl+alt+i";
			command =  "workbench.action.chat.open";
			}
		];
		mutableExtensionsDir = false; # stops vscode from editing ~/.vscode/extensions/* which makes the following extensions actually install

		# installing malware
		extensions = (with pkgs.vscode-extensions; [
			ms-python.vscode-pylance
			ms-vscode-remote.remote-containers
			# ms-vscode-remote.remote-ssh
			ms-azuretools.vscode-docker
			batisteo.vscode-django
			ms-python.python
			mkhl.direnv
			shd101wyy.markdown-preview-enhanced
			ms-toolsai.jupyter
			github.copilot-chat
			
		]) ++ [ #  "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
			(ext "Nix" "bbenoist" "1.0.1" "sha256-qwxqOGublQeVP2qrLF94ndX/Be9oZOn+ZMCFX1yyoH0=") # https://marketplace.visualstudio.com/items?itemName=bbenoist.Nix
			(ext "copilot" "GitHub"  "1.276.1398" "sha256-3ge/JMyzalCgTuOPQPWCrqZMeH0IQRCT+tleg/6mc5A=") # https://marketplace.visualstudio.com/items?itemName=GitHub.copilot
			(ext  "bash-debug" "rogalmic" "0.3.9" "sha256-f8FUZCvz/PonqQP9RCNbyQLZPnN5Oce0Eezm/hD19Fg=") # https://marketplace.visualstudio.com/items?itemName=rogalmic.bash-debug
			(ext "nix-ide" "jnoortheen" "0.3.1" "sha256-05oMDHvFM/dTXB6T3rcDK3EiNG2T0tBN9Au9b+Bk7rI=" ) # https://marketplace.visualstudio.com/items?itemName=jnoortheen.nix-ide
		];
	}; # END VSCODE
}