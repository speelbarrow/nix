{
  inputs = {
    modules.url = "github:speelbarrow/nix/26.05";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-26.05";
    };

  };

  outputs = inputs @ { modules, home-manager, nix-darwin, ... }: let
    stateVersion = "26.05";
  in {
    configuration = nix-darwin.lib.darwinSystem {
      modules = [
        modules.outputs.configuration
        ({ ... }: {
          nixpkgs.system = "aarch64-darwin";
        })
        home-manager.darwinModules.home-manager {
          users.users.speelbarrow.home = "/Users/speelbarrow";
          home-manager = let
            attrs = modules.outputs.home-manager { inherit stateVersion; };
          in builtins.trace attrs.users.speelbarrow.home attrs;
        }
      ];
      specialArgs = { inherit inputs stateVersion; };
    };
  };
}
