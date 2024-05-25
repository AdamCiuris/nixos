{ config, pkgs, ... }:
{

	imports =
		[ # Include the results of the hardware scan.
		../configuration.nix

		../../hardware/bluetooth.nix

		../../system/virtualization/libvirtd.nix

		../../system/specialisations/default-specialisation.nix
		../../system/specialisations/display-desktop-managers.nix
		
		../../system/services/xserver.nix
		];
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
	networking = {
		hostName = "guest"; # Define your hostname.
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
			lock = {
				# hash a password with mkpasswd -m sha-512
				isNormalUser = true;
				description = "my user";
				initialHashedPassword = "$6$m9F21zmzjS6I0O5A$c2ULiXYPzwXW54uVKmakPgPUHC/qY9SnPihsbDoe.BP1wHk2v2Dw5oicK3GruyWEtoYZTyQHc2D3HtMt50DGT1";
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
