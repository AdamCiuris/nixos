{ config, pkgs, ... }:
{

	imports =
		[ # Include the results of the hardware scan.
		../configuration.nix

		../../hardware/bluetooth.nix


		../../system/virtualization/libvirtd.nix
		
		../../system/specialisations/default-specialisation.nix
		../../system/specialisations/display-desktop-managers.nix
		

		../../system/services/mysql.nix
		../../system/services/nextcloud.nix
		../../system/services/xserver.nix
		];

	nix = import ../nix/nixOptions.nix { 
		inherit config pkgs;
		nixPath = [ # echo $NIX_PATH
		"nixpkgs=/home/nyx/.nix-defexpr/channels/nixpkgs"
		"nixos-config=/etc/nixos/top-level-config/variants/dailyDrive.nix"
		];
	};

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
	users ={
		mutableUsers = true; # let's you change the passwords after btw
		users= {
		# set a password with ‘passwd’ $USER.
			nyx = {
				# hash a password with mkpasswd -m sha-512, or with -s $SALT
				isNormalUser = true;
				description = "nyx";
				initialHashedPassword = "$6$7mFX0wL.lFB9nhjR$PUMBogxDPqc5ZVGbUj9QHY.OasKbE7tuEYN.xFmY/G7zTzOCHD39VD3.aSQT6o1j4xtH4pDGYJyKrM2zKB8vG1";
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
	
}
