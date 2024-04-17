{	config, home-manager,lib, pkgs,... }:
let

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

		# programs.home-manager.enable=true;
		home.packages = with pkgs; [
			htop # system monitor
			git # version control
			geckodriver #firefox selenium
			chromedriver # chrome selenium add this to driver_executable_path
			(python3.withPackages (python-pkgs: [
				python-pkgs.pandas
				python-pkgs.numpy
			]))
			# vscodium # open source electron IDE
			# does bootloader.grub.enable = true always have to be commented out for iso gen
			nixos-generators # nixos-generate -f iso -c "/path/to/configuration.nix"
			wget # for downloading files
			gimp # image editing
			ghidra # src code analysis and decompilation
			gradle # for ghidra extensions
			vlc # video player
			# blender # video editor, 3d modeling
			nix-index # for nix search
			xdg-utils # xdg-open
			veracrypt # encryption
			qbittorrent # torrent client
			nomacs # image viewer

			(pkgs.nerdfonts.override { fonts=["DroidSansMono" ]; }) # for vscode
			];
		# BEGIN USER CONFIGS	


		# xdg-open is what gets called from open "file" in terminal

		imports = [
			./configs/shells.nix
			./configs/git.nix
			./configs/vscode.nix
			./configs/xdg.nix
		];
		# END PASTE SPACE
}
