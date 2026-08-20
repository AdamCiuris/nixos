{ config, pkgs, lib, ... }:

{

	imports =
		[ # Include the results of the hardware scan.
		../hardware/bluetooth.nix

		../system/programs/direnv.nix
		../system/programs/motion.nix
		../system/programs/msmtp.nix

		../system/devices/swapDevices.nix

		../system/networking/network.nix
		../system/networking/ports/allOff.nix
		../system/networking/ports/ssh.nix

		../system/services/binary-cache.nix
		../system/services/fail2ban.nix
		../system/services/ffmpeg.nix
		../system/services/jellyfin.nix
		# ../system/services/matrix.nix
		../system/services/mysql.nix
		../system/services/nginx.nix
		../system/services/pipewire.nix
		../system/services/spice-vdagentd.nix
		../system/services/tailscale.nix
		../system/services/tor.nix
		../system/services/xserver.nix

		../system/systemd/directories.nix
		../system/systemd/ffmpeg.nix
		../system/systemd/mullvad-browser.nix
		../system/systemd/power.nix
		../system/systemd/timers.nix

		../hardware-configuration.nix
		];

		programs.nix-ld.enable = true; # for vscode-server
		nix = import ./nix/nixOptions.nix { 


		inherit config pkgs;
		nixPath = [ # echo $NIX_PATH
		"nixpkgs=/home/nyx/.nix-defexpr/channels/nixpkgs"
		"nixos-config=/etc/nixos/top-level-config/variants/dailyDrive.nix"
		];
		# settings = {
		# 	substituters = [
		# 		"cache.sirius.com"
		# 	];
		# 	trusted-public-keys = [
		# 		"cache.sirius.com:aHUH6urBnqoXpmTdAUMT5nwt38iaIn8tdXKW6NH6xUo=%"
		# 	];
		# };
	};
	systemd.enableEmergencyMode = false; # TODO why do i have this? just go into emergency mode
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

	users = 
	 {
		mutableUsers = true; # let's you change the passwords after btw
		users= {
      adamciuris_gmail_com = { # google cloud 26.05 default name
          isNormalUser = true;
          hashedPassword = "$6$m8rdH/A4..rD5jz2$N25rKkOlhcpY9ZK65juGxgHu7.NINXqb0wGUtqu39xxojd2xwuXWpjMO1mpEl7rQGb2aS4BMCa8WJApgoY5Au1";
          extraGroups = [ "wheel" ];
          # Expired ephemeral keys removed. 
          # Google Guest Agent will automatically manage Web SSH keys here.
        };
		  # set a password with ‘passwd’ $USER.
			nyx = lib.mkForce {
				# hash a password with mkpasswd -m sha-512, or with -s $SALT
				isNormalUser = true;
				group = "users";
				description = "nyx";
				initialHashedPassword = "$6$lU2SgMLEUnc2iUNO$c7Q6KluoqxDkBAJgUbjgM97mFw8/MHNgiFYYPzwxZvRhFQdH8P8v7AXsN6D8DZ7DNQeSgzyZ7hF7HG3MOiNYo1";
				# shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				extraGroups = [ 
					"networkmanager"
					"wheel" 
					];
				packages = with pkgs; [
					# zsh
				];
			};
    };
   };
#   services.xserver.enable = true;
  services.xserver.desktopManager.cinnamon.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  networking.enableIPv6 = lib.mkForce false; # ipv4 only pls

	security.rtkit.enable = true;
	environment.systemPackages = with pkgs; [
		vim # text editor, worse
		nano # text editor
		nginx # web server
		baobab # disk usage analyzer
		nmap # network scanner
		firefox
	];
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.ngix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "26.05"; # Did you read the comment?
}
