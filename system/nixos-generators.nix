{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nixos-generators, ... }: {

    # A single nixos config outputting multiple formats.
    # Alternatively put this in a configuration.nix.
    nixosModules.my-machine = { config, ... }: {
      imports = [
        nixos-generators.nixosModules.all-formats
      ];

      nixpkgs.hostPlatform = "x86_64-linux";

      # customize an existing format
      formatConfigs.vmware = { config, ... }: {
        services.openssh.enable = true;
      };

      # define a new format
      formatConfigs.my-custom-format = { config, modulesPath, ... }: {
        imports = [ "${toString modulesPath}/installer/cd-dvd/installation-cd-base.nix" ];
        formatAttr = "isoImage";
        fileExtension = ".iso";
        networking.wireless.networks = {
          # ...
        };
      };

      # the evaluated machine
      nixosConfigurations.my-machine = nixpkgs.lib.nixosSystem {
        modules = [ self.nixosModules.my-machine ];
      };
    };
  };
}