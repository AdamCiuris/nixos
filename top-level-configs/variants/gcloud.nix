{ plasma-manager, config, nixpkgs, pkgs, lib, ... }:
let
  gcloudOrNot = false; # TODO figure out condition for this
  res = if gcloudOrNot 
  then [ # needs --impure
		<nixpkgs/nixos/modules/virtualisation/google-compute-image.nix>
		] 
  else [
		../../hardware-configuration.nix
		../boot/bootloader.nix

  ];
	 filterAttrSet = attrSet: pattern:
    lib.attrsets.filterAttrs (name: value: builtins.match pattern value != null ) attrSet;
	grimoire =  map (a: ../../. +  builtins.toPath "/grimoire/${a}" ) 
		(builtins.filter
			(a: builtins.match  ".*sirius\\.nix" a != null) 
				(builtins.attrNames 
					(filterAttrSet (builtins.readDir ../../grimoire)  "regular")
				)
		);
in 
{
	imports =
		[ # Include the results of the hardware scan.

		../../system/services/openvpn.nix
		../../system/services/xrdp.nix
		../../system/services/pipewire.nix
		../../system/services/openssh.nix
				# ../../system/networking/network.nix # overridden in flake
		../../system/networking/ports/ssh.nix


		../../system/services/ollama.nix


		# ./system/.secrets.nix
		] ++ res ++ grimoire;

	nix = import ../nix/nixOptions.nix { 
		inherit config pkgs;
		nixPath = [ # echo $NIX_PATH
		"nixpkgs=/home/nyx/.nix-defexpr/channels/nixpkgs"
		"nixos-config=/etc/nixos/top-level-config/variants/gcloud.nix"
		];
	};
  	networking = 
        {   
            # bind hostname in import
            enableIPv6 = false; # ipv4 only pls
            # logRefusedConnections =true;# logs are in dmesg or journalctl -k
        };
	networking.hostName = "gcloud"; # Define your hostname.
	# networking.wireless.enable = true;	# Enables wireless support via wpa_supplicant.
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
 #nixpkgs review ???? TODO
 # nixpkgs-review pr 234241

	programs = {
		dconf.enable = true;
		zsh.enable = true;
		};



	services = {
		xserver = {
			enable = true;
			# Configure keymap in X11
			layout = "us";
			xkbVariant = "";
			# KDE
			desktopManager.plasma5.enable = true;
			displayManager.sddm ={
				enable = true; 
			};
		}; # END X11
		spice-vdagentd.enable = true; # enables clipboard sharing between host and guest

	}; # END SERVICES

	# https://nixos.wiki/wiki/Bluetooth
	hardware.bluetooth.enable = false;

	users ={
		mutableUsers = true; # let's you change the passwords after btw
		users= {
			root = {
				# hash a password with mkpasswd -m sha-512
				initialHashedPassword="$6$YRrVyps98/izQa0O$3fR8f/uNEb8B7lXYMu1lE85PZVKp3/Lc8Gc8J2mEwKr9SlUBYGKcbFcWE/SOWnvfRordhUDwv6SXilQ38o.ww1";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				isSystemUser = true;
			}; 
			nyx = {
				isNormalUser = true;
				description = "nyx";
				initialHashedPassword = "$6$7ACOHeLr65U7C1Pb$oNIgMK/8iWH9AbLmhyqlJ.HyUQQst5H7jyV5IGsux4j9X7N/Fwm9Mo8u1ijOmqlGjN5ewEhPt.BsWBt518.Rw1";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				extraGroups = [ "wheel" ];
				packages = with pkgs; [
					zsh
				];
				openssh= {
					authorizedKeys.keys = [ # dXAgdG8gbm8gZ29vZA==
								"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBXPRdUZHO30s+fiHC4HQjVFF2ok3Vh/l4S2SXBdbnXE nyx@nixos"
						];
				};
			};
				tunnelThruMe = {
				isNormalUser = true;
				description = "rdp through ssh tunnel tunnel";
				initialHashedPassword = "$6$ImaOHGRpSLuFOUpF$cPhDbahxmy35ohvYwZIK5BX4o5gvVCeeiOCAaYDCvPPf9geikS.Agw2lCxqoZjHsHS6W/6ksxaplRh2evS1x8.";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				extraGroups = [ "wheel" ];
				packages = with pkgs; [
					zsh
				];
				openssh= {
					authorizedKeys.keys = [ 
						"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP46ikaAUHSjoEB2j/Q0ayebAYgAl5GLkOU3fiKXZsPT nyx@nixos"
						];
				};
			};
			rdp = {
				isNormalUser = true;
				description = "rdp";
				initialHashedPassword = "$6$/uc.82fRtaRDvGGn$n7jEQHRys.AnSha6WJQpu68JkN7JV7ODrQoMT/IX8uaZjf3oa8izOA8MFQl2jGouBxBUpbJpMqPWfM9j6YBHi/";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				extraGroups = [ "wheel" ];
				packages = with pkgs; [
					zsh
				];
			};
		};
	};
	security.pam.services.kwallet = {
		name = "kwallet";
		enableKwallet = false;
	};
}
