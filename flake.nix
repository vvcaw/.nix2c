{
  description = "My System Config";

  # U sadly can't just have a config object that can be used in inputs, thus when changing versions, make sure to change them here as well as down below for home-manager.
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Make sure home-manager uses the same nixpkgs version
    nixvim.url = "github:nix-community/nixvim/nixos-23.11";
    nixvim.inputs.nixpkgs.follows = "nixpkgs"; # Make sure home-manager uses the same nixpkgs version
  };

  outputs = inputs@{ nixpkgs, home-manager, nixvim, ... }: 
  let 
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
    };

    lib = nixpkgs.lib;

  in {
    homeManagerConfigurations = {
      vvcaw = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./users/vvcaw/home.nix
        ];
        
        extraSpecialArgs.nixvim = nixvim;

        extraSpecialArgs.cfg = {
          version = "23.11";
        };
      };
    };

    nixosConfigurations = {
      default = lib.nixosSystem { # This gets selected by hostname or by `.#default`
        inherit system;

        modules = [
          ./system/configuration.nix
        ];
      };
    };
  };
}
