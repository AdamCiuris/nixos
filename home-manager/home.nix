{	config,  pkgs,... }:
let
	shellExtra = ''
		# BEGIN XDG_DATA_DIRS CHECK
		# used to add .desktop files to xdg-mime from nix profile if dne
		# TODO figure out why this gets entered every home-manager switch
		local xdgCheck="$HOME/.nix_profile/share/applications"
		if  [[ ":$XDG_DATA_DIRS:" != *":$xdgCheck:"* ]] ; then
			export XDG_DATA_DIRS="$xdgCheck${":$XDG_DATA_DIRS"}"
		fi	
		# ENd XDG_DATA_DIRS CHECK
		# BEGIN FUNCTIONS
		pvenv() {
			# starts a python virtual environment named after first arg and if a path to a requirements file is provided as second arg it installs it
			# "deactivate" leaves the venv
			local firstArg="$1"
			local activate="./$firstArg/bin/activate"
			python -m venv $firstArg 
			if [ ! -z "$2" ]; then
				source $activate && pip install -r $2 && echo "deactivate to leave"
			else
				source $activate && echo "deactivate to leave"
			fi
		}
		apt-remove() {
			# removes a package from apt and nix
			local firstArg="$1"
			sudo apt-get remove $(apt list --installed "$firstArg" 2>/dev/null | awk -F'/' 'NR>1{print $1}')
		}
		desktopFiles() {
			local firstArg="$1"
			echo "searching for $firstArg in $HOME/.nix-profile/share/applications/..."
			ls ~/.nix-profile/share/applications | grep "$firstArg"
			echo "searching for $firstArg in /usr/share/applications/..."
			ls /usr/share/applications | grep "$firstArg"
		} 
		pathappend() {
			for ARG in "$@"
			do
				if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
					PATH="${"$PATH:"}$ARG"
				fi
			done
		}	# END FUNCTIONS
		pathprepend() {
			for ARG in "$@"
			do
				if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
					PATH="$ARG${":$PATH"}"
				fi
			done
		}	# END FUNCTIONS


		# BEGIN ALIASES
		alias src="source"; 
		alias resrc="source ~/.zshrc";
		alias ...="../../"; 
		alias nrs="sudo nixos-rebuild switch"; 
		alias "g*"="git add *"; 
		alias gcm="git commit -m";
		alias gp="git push"; # conflicts with global-platform-pro, pari
		alias hms="home-manager switch";
		# END ALIASES
		'';
	ext =  name: publisher: version: sha256: pkgs.vscode-utils.buildVscodeMarketplaceExtension {
	mktplcRef = { inherit name publisher version sha256 ; };
	};
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
	home ={
		username = "nyx";
		homeDirectory = "/home/nyx";
		# You should not change this value, even if you update Home Manager. If you do
		# want to update the value, then make sure to first check the Home Manager
		# release notes.
		stateVersion = "23.11";
	};

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = true; # only needed for standalone


	# Home Manager is pretty good at managing dotfiles. The primary way to manage
	# plain files is through 'home.file'.
	home.file = {
		# # Building this configuration will create a copy of 'dotfiles/screenrc' in
		# # the Nix store. Activating the configuration will then make '~/.screenrc' a
		# # symlink to the Nix store copy.
		# ".screenrc".source = dotfiles/screenrc;

		# # You can also set the file content immediately.
		# ".gradle/gradle.properties".text = ''
		#   org.gradle.console=verbose
		#   org.gradle.daemon.idletimeout=3600000
		# '';
	};

	# Home Manager can also manage your environment variables through
	# 'home.sessionVariables'. If you don't want to manage your shell through Home
	# Manager then you have to manually source 'hm-session-vars.sh' located at
	# either
	#
	#  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
	#
	# or
	#
	#  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
	#
	# or
	#
	#  /etc/profiles/per-user/nyx/etc/profile.d/hm-session-vars.sh
	#
	home.sessionVariables = {
		EDITOR = "nano";
	};

	# if not nixOS chsh to /usr/bin/zsh else change users.defaultShell
	# START PASTE SPACE
		nixpkgs.config.allowUnfree=true;
		fonts.fontconfig.enable = true;
		# BEGIN SHELL CONFIGS
		# BEGIN BASH
		programs.bash ={
			enable=true;
			historyControl = ["ignoredups"];
			initExtra = shellExtra;
		}; # END BASH
		# BEGIN ZSH
		programs.zsh = {
			enable = true;
			enableAutosuggestions = true;
			syntaxHighlighting.enable = true;
			oh-my-zsh={
				enable = true;
				# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
				# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/sudo
				# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/systemd
				# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/python
				plugins = [ "git" "sudo" "systemd" "python"];  # a bunch of aliases and a few functions
				theme = "agnoster";  # https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
				};
			initExtra = shellExtra;
			}; # END ZSH
		# programs.home-manager.enable=true;
		home.packages = with pkgs; [
			htop
			git
			geckodriver #firefox selenium
			python313
			python311Packages.pip
			vscode
			wget
			gimp
			ghidra # src code analysis and decompilation
			gradle # for ghidra extensions
			vlc
			xdg-utils
			(pkgs.nerdfonts.override { fonts=["DroidSansMono" ]; }) # for vscode
			];
		# BEGIN USER CONFIGS	
		programs.git = {
			enable = true;
			userName = "Adam Ciuris";
			userEmail = "adamciuris@gmail.com";
		};
		# START VSCODE
		programs.vscode = {
			enable=true;
			userSettings  = {
				"files.autoSave" = "afterDelay";
				"files.autoSaveDelay" = 0;
				"window.zoomLevel"= -1;
				"workbench.colorTheme"= "Tomorrow Night Blue";
				"terminal.integrated.fontFamily" = "DroidSansM Nerd Font"; # fc-list to see all fonts
				"terminal.integrated.rendererType"= "dom"; # allows us to use terminal dev tools
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
					key = "shift+alt+up";
					command = "workbench.action.terminal.resizePaneUp";
					when = "terminalFocus && terminalHasBeenCreated || terminalFocus && terminalProcessSupported";
				}
				{
					key = "shift+alt+down";
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
			];
		}; # END VSCODE
		# xdg-open is what gets called from open "file" in terminal
		imports = [
			./configs/xdg.nix
		];
		# END PASTE SPACE
}
