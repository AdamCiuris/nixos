{ config, pkgs,qubes-nixos-template, lib, ... }:
let 
	 filterAttrSet = attrSet: pattern:
    lib.attrsets.filterAttrs (name: value: builtins.match pattern value != null ) attrSet;

in 
{

	imports =
		[ # Include the results of the hardware scan.
		../configuration.nix

		../../hardware/bluetooth.nix
		../../hardware/opengl.nix

		../../hardware-configuration.nix

		../../system/virtualization/libvirtd.nix
		
		# ../../system/specialisations/default-specialisation.nix
		# ../../system/specialisations/display-desktop-managers.nix

		../../system/virtualization/portfolio-website.nix
		# ../../system/systemd/gunicorn.nix
		# ../../system/services/nginx.nix
		# ../../system/systemd/directories.nix
		../../system/systemd/mullvad-browser.nix
		# ../../system/services/printers.nix

		# ../../system/services/iphone.nix
		# ../../system/services/nextcloud.nix
		../../system/services/tor.nix
		../../system/services/xserver.nix

		../../system/networking/ports/allOff.nix

		# ./renderdoc.nix
		# ../../system/programs/gaming.nix
		# ../../system/services/openvpn.nix

		../../system/programs/direnv.nix

		] ;
	services.xserver.desktopManager.cinnamon.enable = true;
	services.xserver.displayManager.lightdm.enable = true;
	hardware.system76.enableAll = true;
	services.system76-scheduler.enable = true;
	hardware.system76.firmware-daemon.enable = true;

	networking.enableIPv6 = lib.mkForce false; # ipv4 only pls

	nix = import ../nix/nixOptions.nix { 
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



	environment.systemPackages = with pkgs; [
		mangohud # fps monitor for games
		docker-client
		libimobiledevice
	];
	users = 
	 {
		mutableUsers = true; # let's you change the passwords after btw
		users= {
		# set a password with ‘passwd’ $USER.
			nyx = lib.mkForce {
				# hash a password with mkpasswd -m sha-512, or with -s $SALT
				isNormalUser = true;
				group = "users";
				description = "nyx";
				initialHashedPassword = "$6$7mFX0wL.lFB9nhjR$PUMBogxDPqc5ZVGbUj9QHY.OasKbE7tuEYN.xFmY/G7zTzOCHD39VD3.aSQT6o1j4xtH4pDGYJyKrM2zKB8vG1";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				extraGroups = [ 
					"networkmanager"
					"wheel" 
					];
				packages = with pkgs; [
					nurl
					zsh
				];
			};
			root = lib.mkForce  {
				autoSubUidGidRange = false;
				createHome = false;
				cryptHomeLuks = null;
				description = "it's me the system admin are you doing what you're supposed to";
				expires = null;
				extraGroups = [  ];
				group = "root";
				initialHashedPassword = "$6$7mFX0wL.lFB9nhjR$PUMBogxDPqc5ZVGbUj9QHY.OasKbE7tuEYN.xFmY/G7zTzOCHD39VD3.aSQT6o1j4xtH4pDGYJyKrM2zKB8vG1";
				hashedPassword = null;
				hashedPasswordFile = null;
				home = "/root";
				homeMode = "700";
				ignoreShellProgramCheck = false;
				initialPassword = null;
				isNormalUser = false;
				isSystemUser = false;
				linger = false;
				name = "root";
				openssh = {  };
				pamMount = {  };
				password = null;
				passwordFile = null;
				subGidRanges = [  ];
				subUidRanges = [  ];
				uid = 0;
				useDefaultShell = false;
				packages = with pkgs; [
					bash
					nano
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
