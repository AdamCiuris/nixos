#Edit this configuration file to define what should be installed on
# your system.	Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
	imports =
		[ # Include the results of the hardware scan.
		./home-manager/home-manager-module.nix
		# ./system/nixos-generators.nix
		./hardware-configuration.nix
		./nix-alien.nix
		./default-specialisation.nix
		# ./nix-index.nix
		];
	# Bootloader.
	boot.loader.grub = {
		enable = true;
		device = "/dev/vda";
		useOSProber = true;
		splashImage = null;
	};
	# Nix settings
	nix.settings.experimental-features = ["nix-command" "flakes"]; # needed to try flakes from tutorial
    #   programs.command-not-found.enable = false;
    # # for home-manager, use programs.bash.initExtra instead
    # programs.zsh.interactiveShellInit = ''
    #   source ${pkgs.nix-index}/etc/profile.d/command-not-found.sh
    # '';
	networking.hostName = "nixos"; # Define your hostname.
	# networking.wireless.enable = true;	# Enables wireless support via wpa_supplicant.

	# Configure network proxy if necessaryi
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Enable networking
	networking.networkmanager.enable = true;

	# Set your time zone.
	time.timeZone = "America/Chicago";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "en_US.UTF-8";
		LC_IDENTIFICATION = "en_US.UTF-8";
		LC_MEASUREMENT = "en_US.UTF-8";
		LC_MONETARY = "en_US.UTF-8";
		LC_NAME = "en_US.UTF-8";
		LC_NUMERIC = "en_US.UTF-8";
		LC_PAPER = "en_US.UTF-8";
		LC_TELEPHONE = "en_US.UTF-8";
		LC_TIME = "en_US.UTF-8";
	};

	# Enable the X11 windowing system.
	services.xserver.enable = true;
	
	services.spice-vdagentd.enable = true; # enables clipboard sharing

	services.xserver.displayManager.autoLogin.user = null; # don't set
	services.xserver.displayManager.autoLogin.enable = false;

	specialisation = { # Let's you pick the desktop manager in grub
		cinnaminmin = { configuration={
			services.xserver.displayManager.lightdm.enable = true; 
			services.xserver.desktopManager.cinnamon.enable = true;
		};};
		MATE = { configuration={
			services.xserver.displayManager.lightdm.enable = true; 
			services.xserver.desktopManager.mate.enable = true;
		};};
		common = { configuration={
			services.xserver.displayManager.lightdm.enable = true; 
			services.xserver.desktopManager.cde.enable = true;
		};};
		budgie = { configuration={
			services.xserver.displayManager.lightdm.enable = true; 
			services.xserver.desktopManager.budgie.enable = true;
		};};
		KDE = { configuration={
			services.xserver.displayManager.sddm.enable = true;
			services.xserver.desktopManager.plasma5.enable = true;
		};};
		GNOME = { configuration={
			services.xserver.displayManager.gdm.enable = true;
			services.xserver.desktopManager.gnome.enable = true;
		};};
	};

	services.mysql = {
		enable = true;
		package = pkgs.mariadb;
	};

	# Configure keymap in X11
	services.xserver = {
		layout = "us";
		xkbVariant = "";
	};
	
	# Enable CUPS to print documents.
	services.printing.enable = true;

	# Enable sound with pipewire.
	sound.enable = true;
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;
	
	# services.nextcloud = {
	# 	enable = true;
	# 	# package = pkgs.nextcloud;
	# 	# extraConfig = ''
	# 	#   # Add custom configuration options here
	# 	# '';
	# };
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
	};

	# Enable touchpad support (enabled default in most desktopManager).
	# services.xserver.libinput.enable = true;

	#  set a password with ‘passwd’ $USER.
	users.users.nyx = {
		isNormalUser = true;
		description = "nyx";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [
			google-chrome
			firefox
			brave
			zsh
		];
	};

	
	programs.zsh.enable = true;
	# needed for vscode in pkgs
	nixpkgs.config.allowUnfree = true;
	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		vim
		nano # available by default but declare anyways
	];


	# reminder you need to run `nix-garbage-collect -d` as root to delete generations from EFI
	# user one is just profiles and home-manager, i think
	nix.gc.automatic = true;
	nix.gc.options = "--delete-older-than 5d";




	networking.firewall = {
		enable = true; # this is on by default but still declaring it.
		allowedTCPPorts = [  ];
		# allowedUDPPorts = [ ... ];
	};
	services.flatpak.enable = false; # need for postman as postman isn't updated as of 01/28/24
	

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.11"; # Did you read the comment?

}
