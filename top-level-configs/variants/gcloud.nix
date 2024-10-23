{ plasma-manager, config, nixpkgs, pkgs, lib, ... }:
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
		../configuration.nix

		../../system/services/xrdp.nix
		../../system/services/pipewire.nix
		../../system/services/openssh.nix
		../../system/networking/ports/ssh.nix

		# ../../system/systemd/gunicorn.nix
		# ../../system/services/nginx.nix
		# ../../system/services/binary-cache.nix
		# ../../system/services/ollama.nix

		# ../../system/virtualization/open-webui.nix
		# ../../system/virtualization/portfolio-website.nix

		../../system/services/openvpn.nix

		../../grimoire/special.nix

		# ./system/.secrets.nix
		] ;

	nix = import ../nix/nixOptions.nix { 
		inherit config pkgs;
		nixPath = [ # echo $NIX_PATH
		"nixpkgs=/home/nyx/.nix-defexpr/channels/nixpkgs"
		"nixos-config=/etc/nixos/top-level-config/variants/gcloud.nix"
		];
	};
	networking = 
		{   
				hostName = lib.mkForce "gcloud"; # Define your hostname.
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
			# xfce 
			desktopManager.xfce.enable = lib.mkDefault true;
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
               # git clone -c "core.sshCommand=ssh -i ~/.ssh/id_rsa_work" git@github.com:corporateA/webapp.git
                    adamciuris = {
                      isNormalUser = true;
                      description = "temp user for the gcloud keys";
                      initialHashedPassword = "$6$y6FJ9Vy/omqOO2JC$wSx5femKQR1tMWNJ39b8R4sqMwKNNpoYp8lJ/8sRRziOHSOkGM8IC6KJSIjFDTDlRFXOSnLxan8xmAFxK05cv.";
                      shell=pkgs.zsh;
                      useDefaultShell = true; # should be zsh
                      extraGroups = [ 
                        "wheel"
                        "networkmanager"
                        
                         ];
                      packages = with pkgs; [
                        zsh
                      ];
                      openssh= {
                        authorizedKeys.keys = [ # dXAgdG8gbm8gZ29vZA==
							"ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGB5yep7uuNJHD+dzQvO9HvTO8lklNCYO9KR0sQRGlXiRoyn+NCSCy9Nv2881iteb9ZVAGLt62YkVu/wcy1yIu8= google-ssh {\"userName\":\"adamciuris@gmail.com\",\"expireOn\":\"2024-10-22T19:29:16+0000\"}"
							"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfWMu/mh0IpHrQcirTqKssse3l9aBVGbbBamIlmlxz1jgbfMQ9Z28azFj9XMmfZ7nLv5qMSnAQFiJLzcjD0rLayNPq/ATEzb12ZQBxE6/bGTP4CV2gYO+myKLNl1g8aL983gR6yS0ird22fKIHlhugbOIq6RSCnny7kHLHkcKW1R5UIR94tPLVPu1i1ptG26ceIwMQaTOjemZYb31VIhUFo+1xwKFjO4//f873WZiypJc/Ba3g5ublymLLkPNLnscaAJLS7ecK9ED3BHkGEpfb8glRWNvMV+3OV84BtOP569zJxIecBh1zF2xUBqW48kS9jvzCKkY84avHnG1D4FuL google-ssh {\"userName\":\"adamciuris@gmail.com\",\"expireOn\":\"2024-10-22T19:29:21+0000\"}"
							"ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIxmlethQhvy9oRyWDlGPEYO2phtlCDzFaJlwstX239e4D5GeNE+lqqx4BIgmbhKwCGd3Q76iz6ZohrRZTCbz88= google-ssh {\"userName\":\"adamciuris@gmail.com\",\"expireOn\":\"2024-10-22T19:32:07+0000\"}"
							"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC8wZJ1X+p80bqugSY9Pe2fZ/eZWgA7G/gU1ZUX24WYcTqSak58U5vv+0Q4+medzQLCbgu79opuWJwZJnr+vncH4K8okTsoVJhEhDb8X89iiI0auLWc3LXF+HFx0f/jSZV3Rl+BRHmsmX9kebs5gDOO8T+nqoYiD1x/hmb5MBCaUz3E7cGN4vrpa3D8MOG2LBC4etCeCzKq6Yy1+8JslAUT1bG3h+JWAGWgjCaXweMVVY1jvk6GGm28XyOdxOjHFKJqMa4LFrqBkqYaBrGT9W28KGZ1Yh1rT/L4222jXsbAQ5ao5Ax2UX0xcXtWSJhI+9YkRfCNiacKU7iiGGzlpVBb google-ssh {\"userName\":\"adamciuris@gmail.com\",\"expireOn\":\"2024-10-22T19:32:12+0000\"}"
							
                          ];
                      };
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
					"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCqSK7xVD6izqG57PqKJkfeijKzyrptcQ1rbIB4LsMThDZ28DHo2BAW2LSytpJ5insPe9GmqSNAYYCCELOm9XBF4Kg0bnic7eYpCk+Rx7erZ6fHaL+wP+z5Ma9sQnY6u1E0+paNkVIzxbPWF89vuVjCUDyvJkuW86ce7JWbjJVqdCegvFlBAVn4U4y29WTHMTdltejKfTCeiDg2Lov62g6CwJP2IL7a8Ft5C69v3PBVZ9+qQV1BHmCpdU1NJcy1shoMMBh6j0HwynIx1WvmFptx9g7FEi24bb7VyN2f2zK3kAPdbdsLdWJK7FCWPkhFDaJNBbQdto5WlVnwY48UwIq3WnnpWO5I9cAKuA93bs9RirxtmOf+ZW9XHVCqLX3vzy2YTxtAs8i0iCtTRhn95u4C7cgXZXO90CMKZUieYkz0wuP3rQpsCjFIaL1UvwpyfJWulligVPx5vxu0QBRU/y/5wZ+Rb5wvPGlN24mquun6enil3RWH9P7VZrKsWOCPTzc= user@microsoft-vscode"
					"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF7fzeXgtSSbsO67Ma41zvuTEzYuWRSVhXF+Rx6wa0Oj user@vscode"
						];
				};
			};
				tunnelThruMe = {
				isNormalUser = true;
				description = "rdp through ssh tunnel tunnel";
				initialHashedPassword = "$6$CgZ.OzBqrEBHF7gq$XljHcAHZr8kNV85oFy.6/qJ/Kqly9SOOqrqrWe2EnPkYXwQ6wf4tALbSTzDEuWzEJPhuhWheI3f7mCJJNI5Zg.";
				shell=pkgs.zsh;
				useDefaultShell = true; # should be zsh
				extraGroups = [ "wheel" ];
				packages = with pkgs; [
					zsh
				];
				openssh= {
					authorizedKeys.keys = [ 
''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC250vb0xEojVmw9Z7MENQqBp8yn2VosnYxx/K6kuC0dWIB40cyOtLdS0FON+pbgcZ556RsA6H07p1MKNNu7OZj9ecLk7xAp6a5jj5cU4YDBR8UZu3zoaWZWByKC8KH6HSi4a+FMnyARVJRVTvFHCKD/HgQzBlMVsO4OxuoDV49XbdyuqHy6M8WL//Cl5LeJnAz444SX66uy78w/ZtyEdJz3+23G8ROE9dcochBUpASixNZH5Db0cVk7WdMJUheWGE1rIBwMG7bQPJhySDI7ezj5L874Aw4XTkAyMGKpq1kWSZEy2+EfBl7uL3wrgCVX5j6r2SevtxnkAah6qp0nC4JkmHFDejYWL8sEJqwpXLofAXVQbPn9eStyrZOCp0t2iNVzD+nCCboYB99FA7aBRwbCyF8DmOAXV/x/ih6lBNjfekYB7OhNoW9X/1pEZK3tGtbCLmjmEpx7F6vfjMoX36yn93ZJb3mOvJ+W4EX+ZsYXMpW33EmkYZgmBX/VP0rFlk= user@programming-ssh''

						"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP46ikaAUHSjoEB2j/Q0ayebAYgAl5GLkOU3fiKXZsPT nyx@nixos"
						];
				};
			};
			rdp = {
				isNormalUser = true;
				description = "rdp";
				initialHashedPassword = "$6$dTbGWscJfVsamD2q$RsfcFV/eElGmaqh3LYbyH21Un1ni4Zl/BfrIThEt1do9V5idylN300zGtP8m.NY4pDhhy2MF45Xta3SCIw4g9.";
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
