{	config, home-manager,lib, pkgs,... }:
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
		alias gpl="git pull";
		alias gco="git checkout";
		alias gbr="git branch";
		alias gcl="git clone";
		alias glog="git log";
		alias gdiff="git diff";
		alias gstat="git status";
		
		alias hms="rm -f ~/.config/mimeapps.list && home-manager switch";
		alias LS="ls -lAh";
		alias CD="cd";
		alias "cd.."="cd ..";
		alias "cd..."="cd ../..";
		alias "home manager"="home-manager";
		
		# END ALIASES
		'';

	amIstandalone = if ./.  != /etc/nixos/home-manager then true else false; # :l <nixpkgs/nixos>
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
	programs.home-manager.enable = amIstandalone; # only needed for standalone


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
	# reminder to add zsh to /etc/shells
	# START PASTE SPACE
		nixpkgs.config.allowUnfree=true;
		
		nix = {
			
			package = lib.mkIf (amIstandalone) pkgs.nixFlakes;
			extraOptions = ''
				experimental-features = nix-command flakes
			'';
		}; # turn on flakes for user
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
			htop # system monitor
			git # version control
			geckodriver #firefox selenium
			chromedriver # chrome selenium add this to driver_executable_path
			python313 
			python311Packages.pip 
			vscode # microsoft electron IDE
			# does bootloader.grub.enable = true always have to be commented out for iso gen
			nixos-generators # nixos-generate -f iso -c "/path/to/configuration.nix"
			wget # for downloading files
			gimp # image editing
			ghidra # src code analysis and decompilation
			gradle # for ghidra extensions
			vlc # video player
			blender # video editor, 3d modeling
			xdg-utils # xdg-open
			veracrypt # encryption
			qbittorrent # torrent client
			nomacs # image viewer

			(pkgs.nerdfonts.override { fonts=["DroidSansMono" ]; }) # for vscode
			];
		# BEGIN USER CONFIGS	


		# xdg-open is what gets called from open "file" in terminal

		imports = [
			./configs/git.nix
			./configs/vscode.nix
			./configs/xdg.nix
		];
		# END PASTE SPACE
}
