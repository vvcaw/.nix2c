{
  description = "My System Config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs"; # Make sure home-manager uses the same nixpkgs version
  };

  outputs = { nixpkgs, home-manager, ... }: 
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
      };
    };

    nixosConfigurations = {
      matryoshka = lib.nixosSystem { # This gets selected by hostname or by `.#matryoshka`
        inherit system;

        modules = [
          ./system/configuration.nix
        ];
      };
    };
  };
}
