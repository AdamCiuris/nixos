#
#	Common options across all system configurations.
#
{ config, pkgs, lib, ... }:

{

	imports =
		[ # Include the results of the hardware scan.

		../system/devices/swapDevices.nix

		../system/systemd/timers.nix


		# ../system/.secret.nix

		../system/services/fail2ban.nix
		../system/services/pipewire.nix
		../system/services/spice-vdagentd.nix
		# ../system/services/clamav.nix
		../system/networking/network.nix

		../system/programs/msmtp.nix

		../system/virtualization/docker.nix

		]  ;

	systemd.enableEmergencyMode = false;
	home-manager.backupFileExtension = "hmBackup";
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

	
	security.rtkit.enable = true;

	boot.kernel.sysctl = {
		"vm.swappiness" = "10"; # https://www.kernel.org/doc/Documentation/sysctl/vm.txt , only swap if needed
	};
	
	programs.zsh.enable = true; 
	environment.etc = { # reminder this starts in /etc
		"/fail2ban/action.d/msmtp-whois.conf".source = ../etc/msmtp-whois.conf; # TODO figure out how to make relative
		"/nginx" = {
			source = "${pkgs.nginx}";
		};
	};


	environment.systemPackages = with pkgs; [
		vim # text editor, worse
		nano # text editor
		nginx # web server
		baobab # disk usage analyzer
		nmap # network scanner
	];
	
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.ngix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "24.11"; # Did you read the comment?
}
