{ plasma-manager, config, nixpkgs, pkgs, ... }:
{
	imports =
		[ # Include the results of the hardware scan.
		../configuration.nix

		../../hardware-configuration.nix

		../../system/.secret.nix

		
		../../system/programs/msmtp.nix

		../../system/services/openvpn.nix
		../../system/services/fail2ban.nix
		../../system/services/mysql.nix
		../../system/services/nextcloud.nix
		../../system/services/pipewire.nix
		../../system/services/xserver.nix
		../../system/services/flatpak.nix
		];

	networking = {
		hostName = "compclub"; # Define your hostname.
		enableIPv6 = false; # ipv4 only pls
		networkmanager.enable = true;
		firewall = {
			enable = true; # this is on by default but still declaring it.
			allowedTCPPorts = [ 22 ];
			allowedUDPPorts = [  ];
		};
	};
	services = {
		# Enable the OpenSSH server.
		openssh = {
			enable = true;
			permitRootLogin = "no";
			passwordAuthentication = false; # if false require pub key

		};

		# Enable the X11 windowing system.
		xserver = {
			enable = true;
			# Configure keymap in X11
			layout = "us";
			xkbVariant = "";
			# KDE
			desktopManager.plasma5.enable = true;
			displayManager.autoLogin = {
				enable = true;
				user = "chi";
			};
			displayManager.sddm ={
				autoLogin.relogin = true;
				enable = true; 
			};
		}; # END X11

		spice-vdagentd.enable = true; # enables clipboard sharing between host and guest
		# remote desktop
		
		xrdp = {
				enable = true;
				defaultWindowManager = "xfce4-session";
				confDir = /etc/xrdp; # sudo mkdir /etc/xrdp
				port = 8181;
				openFirewall=false; # https://c-nergy.be/blog/?p=14965/
			};
		pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
		};
	};
	
	# https://nixos.wiki/wiki/Bluetooth
	hardware.bluetooth.enable = true;
	programs.zsh.enable = true; 
	users ={
		mutableUsers = true; # let's you change the passwords after btw
		users= {
			teach = {
				isNormalUser = true;
				description = "Professor";
				initialHashedPassword = "$6$PWSjAYmkatpVXMKF$S3szMLBe6NPmTrlgy.yfmweaGuE4GfcyFB6YN0dx.4TV00ww/W6teiUnTdauEkSeqWkPoUwvpiyCddmAuKVpD1";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				extraGroups = 
					[ 
					"wheel" 
					"networkmanager" 
					];
				packages = with pkgs; [
					zsh
				];
				openssh= {
					authorizedKeys.keys = [ 
								"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGhkzqQ3tAvrvkklCRIRyYUhpYdmf2OjDNY/JRzqa79d nyx@nixos"
						];
				};
			};
			rdp = {
				isNormalUser = true;
				description = "rdp";
				initialHashedPassword = "$6$Ls88vu1Bi9jdvXLb$dPNbDd1Gqg6LyH7tQCYCpDrPg/g1vwwsWfuYBNgHusKZvzR0TqI4jWDwRG/Ij7VED57S39/yvxA9ORWMXpLa10";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				extraGroups = 
					[ 
					"wheel" 
					"networkmanager" 
					];
				packages = with pkgs; [
					zsh
				];
			};
			chi = {
				isNormalUser = true;
				description = "club member";
				initialHashedPassword = "$6$lAgJ7CTmOjNkGBWI$mn4XWkzNkuX.NgVjCqpbc2Sflk4m4Dqt/yTfPnFaTdj9/kpiXX.4wVt62N/qa7o5lbYvzA2uXtmDJoAz1wrgP0";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
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