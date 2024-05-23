#  access your package set through nix build, shell, run, etc this flake
{
  description = "precious config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    hardware.url = "github:nixos/nixos-hardware";

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
  };

  outputs = { self, nixpkgs, hardware, home-manager, nixos-generators, flake-utils, ... }@inputs:
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
          networking.wireless.networks = {
            # ...
          };
        };

        "lockdown" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = myPkgs.x86_64-linux;
          specialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules =  [
            # > Our main nixos configuration file <zzzzz
            ./top-level-configs/lockdown.nix
            # home-manager junk
            home-manager.nixosModules.home-manager
            # nix build .\#nixosConfigurations.nixos.config.formats.install-iso -o ./result
            {
              home-manager.extraSpecialArgs = { inherit inputs; }; # Pass flake input to home-manager
              home-manager.users = {
                lock = {
                  imports = [ ./home-manager/lock.nix ];
                  home.stateVersion="23.11"; 
                };
              };
            }
          ];
        };

        "nixos" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = myPkgs.x86_64-linux;
          specialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules =  [
            # > Our main nixos configuration file <zzzzz
            ./top-level-configs/configuration.nix
            # home-manager junk
            home-manager.nixosModules.home-manager
            nixos-generators.nixosModules.all-formats # nix build .\#nixosConfigurations.nixos.config.formats. and hit tab to see all
            # nix build .\#nixosConfigurations.nixos.config.formats.install-iso -o ./result
            {
              home-manager.extraSpecialArgs = { inherit inputs; }; # Pass flake input to home-manager
              home-manager.users = {
                nyx = {
                  imports = [ ./home-manager/home.nix ];
                  home.stateVersion="23.11"; 
                };
              };
            }
          ];
        };
      };
    };
}