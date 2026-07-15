{ inputs, lib, pkgs, stateVersion, ... }: lib.mkMerge [
	{
	  environment.systemPackages = with pkgs; [
	    nix-output-monitor
	  ];
	  nix.settings.experimental-features = "nix-command flakes";
	  system = {
      configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
	    stateVersion = if pkgs.stdenv.hostPlatform.isDarwin then 6 else stateVersion;
    };
	}
  (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
	  security.pam.services.sudo_local.touchIdAuth = true;
  })
]

