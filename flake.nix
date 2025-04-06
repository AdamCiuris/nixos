#  access your package set through nix build, shell, run, etc this flake
{
  description = "precious config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";


    qubes-nixos-template = {
      url = "github:evq/qubes-nixos-template";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # https://github.com/NixOS/nixos-hardware
    # <nixos-hardware/system76> add something like this to hardware-configuration.nix imports

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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

  outputs = { self, nixpkgs, nixpkgs-unstable,nurl, qubes-nixos-template, hardware, lanzaboote, vscode-server, home-manager, nixos-generators, flake-utils, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
      ];
    in
    rec {


      myPkgs = forAllSystems (system:
        import inputs.nixpkgs {
          inherit system;
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
        

        "vm" = nixpkgs.lib.nixosSystem { # slightly modifying stuff for qemu/kvm vms
          system = "x86_64-linux";
          pkgs = myPkgs.x86_64-linux;
          specialArgs = {
            pkgs-unstable = myPkgsUnstable.x86_64-linux;
          };
          modules =  [
            ({ pkgs, lib, fetchFromGitHub, ... }: { # wtf ????
              boot.loader  = lib.mkDefault  {
                systemd-boot.enable = false;
                grub.enable = true;
		            grub.devices =  ["/dev/xvda"] ;
              };

              swapDevices = lib.mkForce [ ];
              services.system76-scheduler.enable = lib.mkForce false;
              hardware.system76.firmware-daemon.enable = lib.mkForce false;

              environment.variables.NIXOS_FLAKE_CONFIGURATION = "vm";
                  

            })
            ./top-level-configs/variants/dailyDrive.nix
            # home-manager junk
            home-manager.nixosModules.home-manager
            # qubes-nixos-template.nixosModules.default
            # qubes-nixos-template.nixosProfiles.default
            # nix build .\#nixosConfigurations.nixos.config.formats.install-iso -o ./result
            ({ lib, pkgs, ... }: {
              home-manager.extraSpecialArgs = { 
                  inherit inputs; 
                  pkgs-unstable = myPkgsUnstable.x86_64-linux;
              }; # Pass flake input to home-manager
              home-manager.users = {
                nyx = {
                  home.homeDirectory = lib.mkForce "/home/nyx";
                  imports = [ ./home-manager/users/nyx.nix ];
                  home.stateVersion="24.11";
                };
              };
            })
          ];
        };
        "vm-xrdp" = nixpkgs.lib.nixosSystem { # slightly modifying stuff for qemu/kvm vms
          system = "x86_64-linux";
          pkgs = myPkgs.x86_64-linux;
          specialArgs = {
            pkgs-unstable = myPkgsUnstable.x86_64-linux;
          };
          modules =  [
            ({ pkgs, lib, fetchFromGitHub, ... }: { # wtf ????
              boot.loader  = lib.mkDefault  {
                systemd-boot.enable = false;
                grub.enable = true;
		            grub.devices =  ["/dev/xvda"] ;
              };

              swapDevices = lib.mkForce [ ];
              services.system76-scheduler.enable = lib.mkForce false;
              hardware.system76.firmware-daemon.enable = lib.mkForce false;

              environment.variables.NIXOS_FLAKE_CONFIGURATION = "vm-xrdp";
                  

            })
            ./top-level-configs/variants/dailyDrive.nix
            ./system/services/xrdp.nix
            # home-manager junk
            home-manager.nixosModules.home-manager
            # qubes-nixos-template.nixosModules.default
            # qubes-nixos-template.nixosProfiles.default
            # nix build .\#nixosConfigurations.nixos.config.formats.install-iso -o ./result
            ({ lib, pkgs, ... }: {
              home-manager.extraSpecialArgs = { 
                  inherit inputs; 
                  pkgs-unstable = myPkgsUnstable.x86_64-linux;
              }; # Pass flake input to home-manager
              home-manager.users = {
                nyx = {
                  home.homeDirectory = lib.mkForce "/home/nyx";
                  imports = [ ./home-manager/users/nyx.nix ];
                  home.stateVersion="24.11";
                };
              };
            })
          ];
        };

      };
    };
}
