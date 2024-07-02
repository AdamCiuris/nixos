#  access your package set through nix build, shell, run, etc this flake
{
  description = "precious config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    hardware.url = "github:nixos/nixos-hardware";

    # nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # https://github.com/NixOS/nixos-hardware
    # <nixos-hardware/system76> add something like this to hardware-configuration.nix imports

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    
    # nix-user-repositories = {
    #   url = "github:rycee/home-manager";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    plasma-manager ={
      url = "github:pjones/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };

  outputs = { self, nixpkgs, hardware, lanzaboote, home-manager, plasma-manager, nixos-generators, flake-utils, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];
    in
    rec {


      myPkgs = forAllSystems (system:
        import inputs.nixpkgs {
          inherit system;
          # NOTE: Using `nixpkgs.config` in your NixOS config won't work
          # Instead, you should set nixpkgs configs here
          # (https://nixos.org/manual/nixpkgs/stable/#idm140737322551056)
          config.allowUnfree = true;
        }
      );
      # vimjoyer iso nonsense https://www.youtube.com/watch?v=-G8mN6HJSZE&



      nixosConfigurations = {
        # https://github.com/nix-community/nixos-generators?tab=readme-ov-file#using-in-a-flake
        formatConfigs.exampleCustomFormat = { config, modulesPath, ... }: {
          imports = [ "${toString modulesPath}/installer/cd-dvd/installation-cd-base.nix" ];
          formatAttr = "isoImage";
          fileExtension = ".iso";
        };
        
        "nixos" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = myPkgs.x86_64-linux;
          specialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules =  [
            lanzaboote.nixosModules.lanzaboote # SECURE BOOT FOR NIXOS
            ({ pkgs, lib, ... }: { # wtf ????
              environment.systemPackages = [
                pkgs.sbctl # secure boot control
              ];
              boot.loader.systemd-boot.enable = lib.mkForce false; # highest prio
              boot.lanzaboote = {
                enable = true;
                pkiBundle = "/etc/secureboot";
              };
              environment.variables.NIXOS_FLAKE_CONFIGURATION = "nixos";
            })

            ./top-level-configs/variants/dailyDrive.nix
            # home-manager junk
            home-manager.nixosModules.home-manager
            hardware.nixosModules.system76
            nixos-generators.nixosModules.all-formats # nix build .\#nixosConfigurations.nixos.config.formats. and hit tab to see all
            # nix build .\#nixosConfigurations.nixos.config.formats.install-iso -o ./result
            {
              home-manager.extraSpecialArgs = { inherit inputs; }; # Pass flake input to home-manager
              home-manager.users = {
                nyx = {
                  imports = [ ./home-manager/users/nyx.nix ];
                  home.stateVersion="24.05"; 
                };
              };
            }
          ];
        };

        "vm" = nixpkgs.lib.nixosSystem { # slightly modifying stuff for qemu/kvm vms
          system = "x86_64-linux";
          pkgs = myPkgs.x86_64-linux;
          specialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules =  [
            ({ pkgs, lib, ... }: { # wtf ????
              boot.loader  = lib.mkForce {
                systemd-boot.enable = false;
                grub.enable = true;
		            grub.devices =  ["/dev/vda"] ;
              };
              swapDevices = lib.mkForce [ ];
              home-manager.users.nyx.home.file = lib.mkForce {}; # no autostarts
              services.system76-scheduler.enable = lib.mkForce false;
              hardware.system76.firmware-daemon.enable = lib.mkForce false;

              environment.variables.NIXOS_FLAKE_CONFIGURATION = "vm";
                  

            })
            ./top-level-configs/variants/dailyDrive.nix
            # home-manager junk
            home-manager.nixosModules.home-manager
            nixos-generators.nixosModules.all-formats # nix build .\#nixosConfigurations.nixos.config.formats. and hit tab to see all
            # nix build .\#nixosConfigurations.nixos.config.formats.install-iso -o ./result
            {
              home-manager.extraSpecialArgs = { inherit inputs; }; # Pass flake input to home-manager
              home-manager.users = {
                nyx = {
                  imports = [ ./home-manager/users/nyx.nix ];
                  home.stateVersion="24.05";
                };
              };
            }
          ];
        };

        "lockdown" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = myPkgs.x86_64-linux;
          specialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules =  [
            # > Our main nixos configuration file <zzzzz
            ./top-level-configs/variants/lockdown.nix
            # home-manager junk
            home-manager.nixosModules.home-manager
            {
              environment.variables.NIXOS_FLAKE_CONFIGURATION = "lockdown";
              home-manager.extraSpecialArgs = { inherit inputs; }; # Pass flake input to home-manager
              home-manager.users = {
                lock = {
                  imports = [ ./home-manager/users/lock.nix ];
                  home.stateVersion="24.05"; 
                };
              };
            }
          ];
        };


        "compclub" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = myPkgs.x86_64-linux;
          specialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules =  [
            # > Our main nixos configuration file <
            ./top-level-configs/variants/club.nix
            home-manager.nixosModules.home-manager
            {
              environment.variables.NIXOS_FLAKE_CONFIGURATION = "compclub";
              home-manager.extraSpecialArgs = { inherit inputs; }; # Pass flake input to home-manager
              home-manager.users = {
                rdp = {
                  imports = [ ./home-manager/users/rdp.nix ];
                  home.stateVersion="24.05"; 
                };
                teach = {
                  imports = [ ./home-manager/users/teach.nix ];
                  home.stateVersion="24.05"; 
                };
                tunnelThruMe = {
                  imports = [ ./home-manager/users/tunnelThruMe.nix ];
                  home.stateVersion="24.05"; 
                };
                chi = {
                  imports = [ ./home-manager/users/clubMember.nix ];
                  home.stateVersion="24.05"; 
                };
              };
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
            }
          ];
        };
        "gcloud" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = myPkgs.x86_64-linux;
          specialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules =  [
            # > Our main nixos configuration file <
            ./top-level-configs/variants/gcloud.nix
            home-manager.nixosModules.home-manager
            ({ pkgs, lib, ... }: { 
                services.vscode-server.enable = true;
              }
            )
            {
              environment.variables.NIXOS_FLAKE_CONFIGURATION = "gcloud";
              home-manager.extraSpecialArgs = { inherit inputs; }; # Pass flake input to home-manager
              home-manager.users = {
                rdp = {
                  imports = [ ./home-manager/users/rdp.nix ];
                  home.stateVersion="24.05"; 
                };
                nyx = {
                  imports = [ ./home-manager/users/nyx.nix ];
                  home.stateVersion="24.05"; 
                };
                tunnelThruMe = {
                  imports = [ ./home-manager/users/tunnelThruMe.nix ];
                  home.stateVersion="24.05"; 
                };
              };
              home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
            }
          ];
        };

      };
    };
}
