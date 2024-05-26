#  access your package set through nix build, shell, run, etc this flake
{
  description = "precious config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    hardware.url = "github:nixos/nixos-hardware";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master"; # https://github.com/NixOS/nixos-hardware
    # <nixos-hardware/system76> add something like this to hardware-configuration.nix imports

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

  outputs = { self, nixpkgs, hardware, home-manager, plasma-manager, nixos-generators, flake-utils, ... }@inputs:
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
                  home.stateVersion="23.11"; 
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
            # nix build .\#nixosConfigurations.nixos.config.formats.install-iso -o ./result
            {
              home-manager.extraSpecialArgs = { inherit inputs; }; # Pass flake input to home-manager
              home-manager.users = {
                lock = {
                  imports = [ ./home-manager/users/lock.nix ];
                  home.stateVersion="23.11"; 
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
              home-manager.extraSpecialArgs = { inherit inputs; }; # Pass flake input to home-manager
              home-manager.users = {
                rdp = {
                  imports = [ ./home-manager/users/rdp.nix ];
                  home.stateVersion="23.11"; 
                };
                teach = {
                  imports = [ ./home-manager/users/teach.nix ];
                  home.stateVersion="23.11"; 
                };
                tunnelThruMe = {
                  imports = [ ./home-manager/users/tunnelThruMe.nix ];
                  home.stateVersion="23.11"; 
                };
                chi = {
                  imports = [ ./home-manager/users/clubMember.nix ];
                  home.stateVersion="23.11"; 
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
            {
              home-manager.extraSpecialArgs = { inherit inputs; }; # Pass flake input to home-manager
              home-manager.users = {
                rdp = {
                  imports = [ ./home-manager/users/rdp.nix ];
                  home.stateVersion="23.11"; 
                };
                nyx = {
                  imports = [ ./home-manager/users/nyx.nix ];
                  home.stateVersion="23.11"; 
                };
                tunnelThruMe = {
                  imports = [ ./home-manager/users/tunnelThruMe.nix ];
                  home.stateVersion="23.11"; 
                };
              };
              home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];
            }
          ];
        };

      };
    };
}