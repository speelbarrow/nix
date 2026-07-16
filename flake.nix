{
  outputs = { ... }: {
    configuration = import ./configuration.nix;
    home-manager = { stateVersion }: {
      extraSpecialArgs = { inherit stateVersion; };
      useGlobalPkgs = true;
      useUserPackages = true;
      users.speelbarrow = import ./home.nix;
    };
  };
}
