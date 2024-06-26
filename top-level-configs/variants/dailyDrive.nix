{ config, pkgs, lib, ... }:
{

	imports =
		[ # Include the results of the hardware scan.
		../configuration.nix

		../../hardware/bluetooth.nix
		../../hardware/opengl.nix

		../../hardware-configuration.nix

		../../system/virtualization/libvirtd.nix
		
		../../system/specialisations/default-specialisation.nix
		../../system/specialisations/display-desktop-managers.nix
		
		../../system/systemd/gunicorn.nix
		../../system/services/nginx.nix
		../../system/services/ollama.nix
		../../system/systemd/directories.nix

		../../system/services/mysql.nix
		../../system/services/iphone.nix
		../../system/services/nextcloud.nix
		../../system/services/tor.nix
		../../system/services/xserver.nix

		../../system/networking/network.nix
		../../system/networking/ports/allOff.nix

		../../system/programs/gaming.nix
		../../system/programs/direnv.nix

		];
	# hardware.system76.enableAll = true;
	services.system76-scheduler.enable = true;
	hardware.system76.firmware-daemon.enable = true;
	nix = import ../nix/nixOptions.nix { 
		inherit config pkgs;
		nixPath = [ # echo $NIX_PATH
		"nixpkgs=/home/nyx/.nix-defexpr/channels/nixpkgs"
		"nixos-config=/etc/nixos/top-level-config/variants/dailyDrive.nix"
		];
	};

	environment.systemPackages = with pkgs; [
		mangohud # fps monitor for games
		docker-client
		libimobiledevice
	];
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
