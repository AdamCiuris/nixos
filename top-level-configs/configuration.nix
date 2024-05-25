{ config, pkgs, ... }:
{

	imports =
		[ # Include the results of the hardware scan.
			./boot/bootloader.nix
			./nix/nixOptions.nix
		];
	# [ -d /sys/firmware/efi/efivars ] && echo "UEFI" || echo "Legacy"

	# Nix settings
	# reminder you need to run `nix-collect-garbage -d` as root to delete generations from EFI
	# user one is just profiles and home-manager, i think

	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
	networking = {
		hostName = "nixos"; # Define your hostname.
		enableIPv6 = false; # ipv4 only pls
		# wireless.enable = true;	# Enables wireless support via wpa_supplicant.
		networkmanager.enable = true;
		firewall = {
			enable = true; # this is on by default but still declaring it.
			allowedTCPPorts = [  ];
			allowedUDPPorts = [  ];
		};
	};

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
