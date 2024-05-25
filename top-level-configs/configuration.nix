{ config, pkgs, ... }:
{

	imports =
		[ # Include the results of the hardware scan.
		./boot/bootloader.nix

		../hardware-configuration.nix

		../system/.secret.nix

		../system/services/openvpn.nix
		../system/services/fail2ban.nix
		../system/services/pipewire.nix

		../system/programs/msmtp.nix
		../system/services/flatpak.nix

		../system/virtualization/docker.nix


		];
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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

	services.spice-vdagentd.enable = true; # enables clipboard sharing between vms

	# Enable CUPS to print documents.
	services.printing.enable = false;

	sound.enable = true; # Whether to enable ALSA sound
	
	security.rtkit.enable = true;

	programs.zsh.enable = true; 
	environment.etc = { # reminder this starts in /etc
		"/fail2ban/action.d/msmtp-whois.conf".source = /etc/nixos/etc/msmtp-whois.conf; # TODO figure out how to make relative
	};
	environment.systemPackages = with pkgs; [
		vim
		nano 
	];
	
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.11"; # Did you read the comment?
}
