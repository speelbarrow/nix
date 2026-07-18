{ inputs, lib, pkgs, stateVersion, ... }: lib.mkMerge [
  {
    nix.settings.experimental-features = "nix-command flakes";
    nixpkgs.overlays = [
      (super: self: {
        calibre = if self.stdenv.isDarwin then self.stdenv.mkDerivation rec {
          inherit (self.calibre) name version;
          meta = {
            inherit (self.calibre.meta) homepage description longDescription changelog license maintainers platforms;
          };
          src = self.fetchurl {
            url = "https://download.calibre-ebook.com/${version}/calibre-${version}.dmg";
            hash = "sha256-aKCRpCBzUYQtpQn7oKvsmvu4Mkmfh1Lm/NmWQlstqII=";
          };
          nativeBuildInputs = [ super._7zz ];
          unpackCmd = "7zz x -snld \"$curSrc\"";
          sourceRoot = ".";
          installPhase = ''
            runHook preInstall

            mkdir -p $out/Applications
            cp -a calibre.app $out/Applications

            runHook postInstall
          '';
        } else self.calibre;
      })
    ];
    system = {
      configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
      stateVersion = if pkgs.stdenv.isDarwin then 6 else stateVersion;
    };
  }
  (lib.mkIf pkgs.stdenv.isDarwin {
    security.pam.services.sudo_local.touchIdAuth = true;
  })
]
