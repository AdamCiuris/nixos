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

		../../system/systemd/gunicorn.nix
		../../system/services/nginx.nix
		../../system/services/binary-cache.nix
		../../system/services/ollama.nix

		../../system/virtualization/open-webui.nix
		../../system/virtualization/portfolio-website.nix

		../../system/services/openvpn.nix


		# ./system/.secrets.nix
		] ++ grimoire;

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
               
                    adamciuris = {
                      isNormalUser = true;
                      description = "temp user for the gcloud keys";
                      initialHashedPassword = "$6$7ACOHeLr65U7C1Pb$oNIgMK/8iWH9AbLmhyqlJ.HyUQQst5H7jyV5IGsux4j9X7N/Fwm9Mo8u1ijOmqlGjN5ewEhPt.BsWBt518.Rw1";
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
                                "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPJrTWeuAC/XrXSZTTE3dbQA0vGYlxlbbxFkzAGAwOt/waBq54ZOBixpruCojg9Ilh5h4vLFOAZ3ri5Fz8I6/L4= google-ssh {\"userName\":\"adamciuris@gmail>"
		                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCIyZnsaSxB13/oRhitVWS8F7oH74cFfTucDoXjnfyZNmiDI7sDbqELYfpyfkbsN0msJco3Lo9IWYVWnmJSqQ9QTAHRvzV9nHS1nR1QhQTCnInqt079S/G7eqtAS5dJ6gxMZlekzV91mLXbGPMhGGAbkUeC2S1D4B2N+pZGFMGgXQi6qRK9odPK>"
                                "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBPJrTWeuAC/XrXSZTTE3dbQA0vGYlxlbbxFkzAGAwOt/waBq54ZOBixpruCojg9Ilh5h4vLFOAZ3ri5Fz8I6/L4= normal"
                              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDxvzqLskwk2epl9z7P6ai+IVm5TBOWzf/RfZ7afYDq1 nyx@nixos" # ADD THE GCLOUD KEYS HERE

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
					"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyH6H6NaDVdtc1HIiY0dkpeS9J4PBWYkFbxJF7D7rbT3+Xb0x0ho8clgHWhUb7ohA6dYrniRAx0oB71kN8k+14v/9Q2VR0+QUEpV3VTRVGf/b4BeuS5o+JdkbStEb871yW3JPa4vwTQwmImI590QE1lOPO7CEgsTF9OV8wJjGZXoZizWLmx118sZRMN/fDh6RRfLIzEa/ZyIc+UnV+iH5IBvs4Pi4pQ6HXyCs749iIEiF3S0CT/N7R+70nJ96QZ6SBJFAT6vFinMZsBA0STls1kMRhROo3GHdGf7Uu9RdSNp5nsrDqcMhAHxymmfjZuiyy7Es3rmpLHYh2fCox43zwhC8B6P9Q3NxUm0IIbBowe4E0Ql+Ph8s6f1h6vDtjN69ZK5n+0TvSJaYmKEVhV1kAf30IMSH9gIFsvdUFg/krZbv6AAuk7h07LKlHr+wPzQjoeuTakFW/maLgP/zjvMiyWaujlB11EIcR7NhgtBu8VCJ0ZRglf0Vhz5E8FAYygiE= user@programming-ssh"
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
