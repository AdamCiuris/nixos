{	config,lib, pkgs,... }:
let
	amIstandalone = if ./.  != /etc/nixos/home-manager then true else false; # :l <nixpkgs/nixos>
in
{

	# Let Home Manager install and manage itself.
	programs.home-manager.enable = amIstandalone; # only needed for standalone
	nixpkgs.config.allowUnfree = true;

	home.file = { # starts at ~/.config
	};

	home.sessionVariables = {
		EDITOR = "nano";
	};

	# if not nixOS chsh to /usr/bin/zsh else change users.defaultShell
	# reminder to add zsh to /etc/shells
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
		# does bootloader.grub.enable = true always have to be commented out for iso gen
		nixos-generators # nixos-generate -f iso -c "/path/to/configuration.nix"
		wget # for downloading files
		gimp # image editing
		ghidra # src code analysis and decompilation
		gradle # for ghidra extensions
		vlc # video player
		nix-index # for nix search
		xdg-utils # xdg-open
		qbittorrent # torrent client
		nomacs # image viewer
		discord # chat client
		# brave # chromium based browser, enabled in brave.nix
		# firefox # open source browser, enabled in fiyafox.nix
		libreoffice # office suite
		xclip # cat into clipboard with xclip -sel clip < file
		(pkgs.nerdfonts.override { fonts=["DroidSansMono" ]; }) # for vscode
		];

}
