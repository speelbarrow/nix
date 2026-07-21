{
  inputs = {
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
    fenix.url = "github:nix-community/fenix";
  };
  outputs = { fenix, nixvim, ... }: {
    configuration = import ./configuration.nix;
    home-manager = { stateVersion }: {
      extraSpecialArgs = { inherit fenix nixvim stateVersion; };
      useUserPackages = true;
      users.speelbarrow = import ./home.nix;
    };
  };
}
