{
  outputs = { ... }: {
    configuration = import ./configuration.nix;
    home-manager = stateVersion: {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.speelbarrow = (import ./home.nix) stateVersion;
    };
  };
}
