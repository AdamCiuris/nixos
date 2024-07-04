{ config, pkgs, lib, ... }:
let 
	 filterAttrSet = attrSet: pattern:
    lib.attrsets.filterAttrs (name: value: builtins.match pattern value != null ) attrSet;
	grimoire =  map (a: ./. + "/spells/${a}" ) 
		(builtins.filter
			(a: builtins.match  ".*sirius\\.nix" a != null) 
				(builtins.attrNames 
					(filterAttrSet (builtins.readDir ../../spells)  "regular")
				)
		);
in 
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

		] ++ grimoire;
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
			bael = {
				# hash a password with mkpasswd -m sha-512, or with -s $SALT
				isNormalUser = true;
				description = "bael - no sudo, vscode.";
				initialHashedPassword = "$6$iTFD.aCs0URORQdw$WHydkMWviBZhIQMoB2Dn2a.e5fwL/BQuBm7Fi5/Ftw0kPmsicvZfvo2ni8WJl94G11k1CDW9bHLCK3hZvgiV91";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				extraGroups = [ # no sudoers?
					"networkmanager"
					];
				packages = with pkgs; [
					zsh
				];
			};
		};
	};
	
}
