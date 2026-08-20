{ config, pkgs,  ...}:
let 
	ext =  name: publisher: version: sha256: pkgs.vscode-utils.buildVscodeMarketplaceExtension {
	mktplcRef = { inherit name publisher version sha256 ; };
	};
	extOpenVsx = publisher: extName: version: sha256: 
    pkgs.vscode-utils.buildVscodeExtension {
      pname = "${publisher}-${extName}"; # <-- Explicitly set pname
      name = "${publisher}-${extName}-${version}"; # <-- Fallback for older nixpkgs
      vscodeExtPublisher = publisher;
      vscodeExtName = extName;
      vscodeExtUniqueId = "${publisher}.${extName}";
      version = version;
      src = pkgs.fetchurl {
        url = "https://open-vsx.org/api/${publisher}/${extName}/${version}/file/${publisher}.${extName}-${version}.vsix";
        inherit sha256;
      };
    };
in
{
	programs.vscodium = {
#		package=pkgs.unstable.vscodium;
		enable=true;
		profiles.default = {
			userSettings  = {
				"files.autoSave" = "afterDelay";
				"files.autoSaveDelay" = 0;
				"window.zoomLevel"= -1;
				# "files.exclude" = ""; # stop excluding files please
				"workbench.colorTheme"= "Tomorrow Night Blue";
				"editor.multiCursorModifier" = "ctrlCmd"; # ctrl + click for multi cursor
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
					key = "alt+k";
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
			# installing malware
			extensions = (with pkgs.unstable.vscode-extensions; [
				ms-python.vscode-pylance
				ms-vscode-remote.remote-containers
				# ms-vscode-remote.remote-ssh
				ms-azuretools.vscode-docker
				batisteo.vscode-django
				ms-python.python
				mkhl.direnv
				shd101wyy.markdown-preview-enhanced
				ms-toolsai.jupyter


				# it is unfortunately faster to update these extensions using their specific versions below
			]) ++ [ #  "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
				(ext "Nix" "bbenoist" "1.0.1" "sha256-qwxqOGublQeVP2qrLF94ndX/Be9oZOn+ZMCFX1yyoH0=") # https://marketplace.visualstudio.com/items?itemName=bbenoist.Nix
				(ext  "bash-debug" "rogalmic" "0.3.9" "sha256-f8FUZCvz/PonqQP9RCNbyQLZPnN5Oce0Eezm/hD19Fg=") # https://marketplace.visualstudio.com/items?itemName=rogalmic.bash-debug
				(extOpenVsx "jeanp413" "open-remote-ssh" "0.3.1" "c6f16b225ab86925f2bd9e8cc5ba31e614978ccfa120f1509bdf6e99e5bef13f")
				# (ext  "gemini-cli-vscode-ide-companion" "Google" "0.25.2" "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=") # https://marketplace.visualstudio.com/items?itemName=Google.gemini-cli-vscode-ide-companion
				(ext "nix-ide" "jnoortheen" "0.5.5" "sha256-epdEMPAkSo0IXsd+ozicI8bjPPquDKIzB3ONRUYWwn8=" ) # https://marketplace.visualstudio.com/items?itemName=jnoortheen.nix-ide
			];
		};
		mutableExtensionsDir = false; # stops vscode from editing ~/.vscode/extensions/* which makes the following extensions actually install
	}; # END VSCODE
}
