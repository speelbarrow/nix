{
  inputs.nixvim.url = "github:nix-community/nixvim/nixos-26.05";
  outputs = { nixvim, ... }: {
    configuration = import ./configuration.nix;
    home-manager = { stateVersion }: {
      extraSpecialArgs = { inherit nixvim stateVersion; };
      useGlobalPkgs = true;
      useUserPackages = true;
      users.speelbarrow = import ./home.nix;
    };
  };
}
