{ config, pkgs, ... }:
{

	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
		./hardware/bluetooth.nix

		./system/.secret.nix

		./system/virtualization/libvirtd.nix
		
		./system/specialisations/default-specialisation.nix
		./system/specialisations/display-desktop-managers.nix
		
		./system/programs/msmtp.nix

		./system/services/openvpn.nix
		./system/services/fail2ban.nix
		./system/services/mysql.nix
		./system/services/nextcloud.nix
		./system/services/pipewire.nix
		./system/services/xserver.nix
		./system/services/flatpak.nix

		];
	# tells
	# [ -d /sys/firmware/efi/efivars ] && echo "UEFI" || echo "Legacy"
  boot.loader = {
		 systemd-boot.enable = true;
		 efi.canTouchEfiVariables = true;
		 efi.efiSysMountPoint = "/boot";
#		grub = {
#			enable = true;
#			efiSupport = true;
#			useOSProber = true;
#			splashImage = null;
#		};
	};
#	boot.loader.grub.devices = [ "nodev" ];
#
	# Nix settings
	nix.settings.experimental-features = ["nix-command" "flakes"]; # needed to try flakes from tutorial
	networking.hostName = "nixos"; # Define your hostname.
	networking.wireless.enable = false;	# Enables wireless support via wpa_supplicant.

	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	networking.networkmanager.enable = true;

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

	services.spice-vdagentd.enable = true; # enables clipboard sharing

	# Enable CUPS to print documents.
	services.printing.enable = false;

	sound.enable = true; # Whether to enable ALSA sound
	
	security.rtkit.enable = true;

	users ={
		mutableUsers = true; # let's you change the passwords after btw
		users= {
		# set a password with ‘passwd’ $USER.
			nyx = {
				# hash a password with mkpasswd -m sha-512
				isNormalUser = true;
				description = "nyx";
				initialHashedPassword = "$6$7ACOHeLr65U7C1Pb$oNIgMK/8iWH9AbLmhyqlJ.HyUQQst5H7jyV5IGsux4j9X7N/Fwm9Mo8u1ijOmqlGjN5ewEhPt.BsWBt518.Rw1";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				extraGroups = [ 
					"networkmanager"
					"wheel" 
					];
				packages = with pkgs; [
					zsh
				];
			};
		};
	};
	programs.zsh.enable = true; 
	environment.etc = {
		# reminder this starts in /etc
		"/fail2ban/action.d/msmtp-whois.conf".source = /etc/nixos/environment/msmtp-whois.conf; # TODO figure out how to make relative
	};
	environment.systemPackages = with pkgs; [
		vim
		nano 
	];
	# reminder you need to run `nix-collect-garbage -d` as root to delete generations from EFI
	# user one is just profiles and home-manager, i think
	nix.gc.automatic = true;
	nix.gc.options = "--delete-older-than 5d";

	networking.firewall = {
		enable = true; # this is on by default but still declaring it.
		allowedTCPPorts = [  ];
		allowedUDPPorts = [  ];
	};
	
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.11"; # Did you read the comment?

}
