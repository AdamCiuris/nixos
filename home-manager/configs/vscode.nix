{ config, pkgs, lib, ... }:
let 
	ext =  name: publisher: version: sha256: pkgs.vscode-utils.buildVscodeMarketplaceExtension {
	mktplcRef = { inherit name publisher version sha256 ; };
	};
in
{
  imports = [
    ./vscodium.nix
  ];
	programs.vscode = {
		package= lib.mkForce pkgs.vscode;
		userSettings  = lib.mkForce {
			"files.autoSave" = "afterDelay";
			"files.autoSaveDelay" = 0;
			"window.zoomLevel"= -1;
			"files.exclude" = ""; # stop excluding files please
			"workbench.colorTheme"= "Red";
			"editor.multiCursorModifier" = "ctrlCmd"; # ctrl + click for multi cursor
			"terminal.integrated.fontFamily" = "DroidSansM Nerd Font"; # fc-list to see all fonts
		};
		# should just add new entries...
		extensions = (with pkgs.vscode-extensions; [
		]) ++ [ #  "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
			(ext "remote-server" "ms-vscode"  "1.5.0" "sha256-OaLCYdAqPRppxu4bNOig87bwi0brhAW91I22IBUWjhA=") # https://marketplace.visualstudio.com/items?itemName=ms-vscode.remote-server
			(ext "remote-ssh" "ms-vscode-remote"  "0.109.0" "sha256-RlrCI5MPndz77eyHeW5BxJ3AuCdwMq8qdRcogz/pekY=") # https://https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh
		];
  };
}