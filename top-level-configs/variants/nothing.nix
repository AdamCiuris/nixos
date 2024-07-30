{  config, nixpkgs, pkgs, lib, ... }:
let
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
    ../boot/bootloader.nix

    ../../hardware/bluetooth.nix
		../../hardware-configuration.nix

		../../system/networking/network.nix
		../../system/networking/ports/allOff.nix
		../../system/services/pipewire.nix
		# ../../system/virtualization/libvirtd.nix
		../../system/services/openvpn.nix

		] ++ grimoire;

	networking.enableIPv6 = lib.mkForce false; # ipv4 only pls
	systemd.enableEmergencyMode = false;

	nix = import ../nix/nixOptions.nix { 
		inherit config pkgs;
		nixPath = [ # echo $NIX_PATH
		"nixpkgs=/home/nyx/.nix-defexpr/channels/nixpkgs"
		"nixos-config=/etc/nixos/top-level-config/variants/nothing.nix"
		];
	};
	networking = 
		{   
				hostName = lib.mkForce "byleth"; # Define your hostname.
		};
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


	services = {
		xserver = {
			enable = true;
			# Configure keymap in X11
			layout = "us";
			xkbVariant = "";
			displayManager.lightdm.enable = true; 
      desktopManager.xfce.enable = true;
		}; # END X11

	}; # END SERVICES

	# https://nixos.wiki/wiki/Bluetooth
	hardware.bluetooth.enable = lib.mkForce false;

	environment.systemPackages = with pkgs; [
		xfce.xfce4-pulseaudio-plugin
	];
	users ={
		mutableUsers = true; # let's you change the passwords after btw
		users= {
			root = {
				# hash a password with mkpasswd -m sha-512
				initialHashedPassword="$6$YRrVyps98/izQa0O$3fR8f/uNEb8B7lXYMu1lE85PZVKp3/Lc8Gc8J2mEwKr9SlUBYGKcbFcWE/SOWnvfRordhUDwv6SXilQ38o.ww1";
				isSystemUser = true;
			}; 
			sagittae = {
				isNormalUser = true;
				packages = with pkgs; [
          pkgs.firefox
        ];
				description = "slim config";
				initialHashedPassword = "$6$7mFX0wL.lFB9nhjR$PUMBogxDPqc5ZVGbUj9QHY.OasKbE7tuEYN.xFmY/G7zTzOCHD39VD3.aSQT6o1j4xtH4pDGYJyKrM2zKB8vG1";
				extraGroups = [ 
          "wheel"
          "networkmanager"
         ];
			};
		};
	};

  	sound.enable = true; # Whether to enable ALSA sound
	
	security.rtkit.enable = true;

	boot.kernel.sysctl = {
		"vm.swappiness" = "10"; # https://www.kernel.org/doc/Documentation/sysctl/vm.txt , only swap if needed
	};
}
