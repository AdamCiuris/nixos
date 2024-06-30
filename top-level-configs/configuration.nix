#
#	Common options across all system configurations.
#
{ config, pkgs, ... }:
{

	imports =
		[ # Include the results of the hardware scan.
		./boot/bootloader.nix

		../system/devices/swapDevices.nix

		../system/systemd/timers.nix


		../system/.secret.nix

		../system/services/openvpn.nix
		../system/services/fail2ban.nix
		../system/services/pipewire.nix
		../system/services/flatpak.nix
		../system/services/spice-vdagentd.nix
		../system/services/clamav.nix

		../system/programs/msmtp.nix

		../system/virtualization/docker.nix


		];

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

	# Enable CUPS to print documents.
	services.printing.enable = false;

	sound.enable = true; # Whether to enable ALSA sound
	
	security.rtkit.enable = true;

	programs.zsh.enable = true; 
	environment.etc = { # reminder this starts in /etc
		"/fail2ban/action.d/msmtp-whois.conf".source = /etc/nixos/etc/msmtp-whois.conf; # TODO figure out how to make relative
		"/nginx" = {
			source = "${pkgs.nginx}";
		};
	};
	environment.systemPackages = with pkgs; [
		vim
		nano 
		nginx
		baobab
	];
	
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "24.05"; # Did you read the comment?
}
