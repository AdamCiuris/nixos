#  access your package set through nix build, shell, run, etc this flake
{
  description = "precious config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";



    # nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # https://github.com/NixOS/nixos-hardware
    # <nixos-hardware/system76> add something like this to hardware-configuration.nix imports
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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

    vscode-server = {
      url = "github:nix-community/nixos-vscode-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nurl = {
      url = "github:nix-community/nurl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nur, nixpkgs, nixpkgs-unstable,nurl, hardware, lanzaboote, vscode-server, home-manager, nixos-generators, flake-utils, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"

      ];
    in
    rec {


      myPkgs = forAllSystems (system:
        import inputs.nixpkgs {
          inherit system;
          overlays =  [ inputs.nur.overlays.default 
      (final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true; # Pass config to the unstable import too!
        };
      })
          ];
# 2. Custom overlay for unstable packages
          config.allowUnfree = true;
        }
        
      );
      myPkgsUnstable = forAllSystems (system:
        import inputs.nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        }
      );
      # vimjoyer iso nonsense https://www.youtube.com/watch?v=-G8mN6HJSZE&



      nixosConfigurations = {
        # https://github.com/nix-community/nixos-generators?tab=readme-ov-file#using-in-a-flake
        

        "pc" = nixpkgs.lib.nixosSystem { # slightly modifying stuff for qemu/kvm vms
          system = "x86_64-linux";
          pkgs = myPkgs.x86_64-linux;
          specialArgs = {
            inherit inputs;
            pkgs-unstable = myPkgsUnstable.x86_64-linux;
          };



          modules =  [

            ({ pkgs, lib, fetchFromGitHub, ... }: { # wtf ????
              boot.loader.systemd-boot.enable = true;
              boot.loader.efi.canTouchEfiVariables = true;
              boot.initrd.luks.devices = {
                crypted = {
                  device = "/dev/disk/by-uuid/dec3bf87-dd58-4f79-b035-f14b36016691";
                  preLVM = true;
                };
                storage = {
                  device = "/dev/disk/by-uuid/63be47d3-6c3e-49c3-8fab-4a31d73c9b1f";
                  preLVM = true;
                };
              };	
              fileSystems."/mnt/storage" = {
                  device = "/dev/mapper/hdd-storage";
                  fsType = "ext4";
                };

              swapDevices = lib.mkForce [ ];
              boot.kernelParams = [ "processor.max_cstate=4" "amd_iomu=soft" "idle=nomwait"];
              boot.kernelPackages = pkgs.linuxPackages_latest;
              environment.variables.NIXOS_FLAKE_CONFIGURATION = "pc";
                  

            })
            ./top-level-configs/variants/dailyDrive.nix
            # home-manager junk
            home-manager.nixosModules.home-manager

            ({ lib, pkgs, ... }: {

              home-manager.useGlobalPkgs = true;
              home-manager.extraSpecialArgs = { 
                  inherit inputs; 
                  pkgs-unstable = myPkgsUnstable.x86_64-linux;
              }; # Pass flake input to home-manager
              home-manager.users = {
                nyx = {
                  home.homeDirectory = lib.mkForce "/home/nyx";
                  imports = [ ./home-manager/users/nyx.nix ];
                  home.stateVersion="25.05";
                };
                bwiuh = {
                  home.homeDirectory = lib.mkForce "/home/bwiuh";
                  imports = [ ./home-manager/users/bwiuh.nix ];
                  home.stateVersion="25.05";
                };
              };
            })
          ];
        };


      };
    };
}
