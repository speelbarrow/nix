{ pkgs, lib, inputs, stateVersion, ... }: lib.mkMerge [
  {
    nix.settings.experimental-features = "nix-command flakes";
    system = {
      configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
      stateVersion = if pkgs.stdenv.isDarwin then 6 else stateVersion;
    };
  }
  (with pkgs; lib.mkIf stdenv.isDarwin {
    environment.pathsToLink = [ "/libexec" ]; # required for `container`, nixpkgs#445648
    security.pam.services.sudo_local.touchIdAuth = true;
  })
]
