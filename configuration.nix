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
		# ./ghidra.nix # nsa decompiler
		];
	# Bootloader.
	# boot.loader.grub.enable = true;
	boot.loader.grub.device = "/dev/vda";
	boot.loader.grub.useOSProber = true;
	# Nix settings
	nix.settings.experimental-features = ["nix-command" "flakes"]; # needed to try flakes from tutorial

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
	# Enable cinnamon desktop environment.
	services.xserver.displayManager.lightdm.enable = true; # lightweight display manager, "greeters" for 
	services.xserver.desktopManager.cinnamon.enable = true;

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
	
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		# If you want to use JACK applications, uncomment this
		#jack.enable = true;

		# use the example session manager (no others are packaged yet so this is enabled by default,
		# no need to redefine it in your config for now)
		#media-session.enable = true;
	};

	# Enable touchpad support (enabled default in most desktopManager).
	# services.xserver.libinput.enable = true;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.nyx = {
		isNormalUser = true;
		description = "nyx";
		extraGroups = [ "networkmanager" "wheel" ];
		packages = with pkgs; [
			google-chrome
			firefox
			brave
			zsh
	
		#	thunderbird
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



	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	# programs.mtr.enable = true;
	# programs.gnupg.agent = {
	#	 enable = true;
	#	 enableSSHSupport = true;
	# };

	# List services that you want to enable:

	# Enable the OpenSSH daemon.
	# services.openssh.enable = true; # TODO maybe

	networking.firewall = {
		enable = true; # this is on by default but still declaring it.
		allowedTCPPorts = [  ];
		# allowedUDPPorts = [ ... ];
	};
	# Or disable the firewall altogether.
	services.flatpak.enable = true; # need for postman as postman isn't updated as of 01/28/24


	

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.11"; # Did you read the comment?

}
