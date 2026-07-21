{
  pkgs,
  lib,
  stateVersion,
  ...
}:
{
  imports = [
    ./neovim
  ];
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (super: self: {
        calibre = if self.stdenv.isDarwin then self.stdenv.mkDerivation rec {
          inherit (self.calibre) name version;
          meta = {
            inherit (self.calibre.meta) homepage description longDescription changelog license maintainers platforms;
          };
          src = self.fetchurl {
            url = "https://download.calibre-ebook.com/${version}/calibre-${version}.dmg";
            hash = "sha256-MAwazx+LlB4mXQ+MOfxgjDz+qGWjFwLghGQ9U2t4yVE=";
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
  };
  home =
    with pkgs;
    lib.mkMerge [
      {
        packages = [
          # order is important!
          llvmPackages.libcxxClang
          llvmPackages.libllvm
          llvmPackages.libcxx

          cargo
          cargo-generate
          nerd-fonts.jetbrains-mono
          nix-output-monitor
          rustc
          tree
        ];
        inherit stateVersion;
      }
      (lib.mkIf stdenv.isDarwin {
        packages = [
          container
        ];
      })
    ];
  programs = {
    calibre.enable = true;
    git = {
      enable = true;
      ignores = if pkgs.stdenv.isDarwin then [ ".DS_Store" ] else [ ];
      settings = {
        core.editor = "nvim";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        user = {
          name = "Noah Friedman";
          email = "speelbarrow@speely.net";
        };
      };
      signing = {
        key = null;
        signByDefault = true;
      };
    };
    google-chrome.enable = true;
    gpg = {
      enable = true;
      publicKeys = [
        { source = ./gmail.pub.asc; }
        { source = ./speely.pub.asc; }
      ];
    };
    ghostty = {
      enable = true;
      package = with pkgs; if stdenv.isDarwin then ghostty-bin else ghostty;
      enableZshIntegration = true;
      settings = {
        font-family = "JetBrainsMono Nerd Font";
        font-style-bold = "ExtraBold";
        font-style-bold-italic = "ExtraBold-Italic";
        font-size = 14;
        font-synthetic-style = false;
        theme = "Dracula+";
        cursor-style = "underline";
        cursor-click-to-move = true;
        background-opacity = 0.9;
        window-padding-balance = true;
        quit-after-last-window-closed = true;
        shell-integration-features = "no-cursor,ssh-terminfo";
        bold-is-bright = true;
        auto-update = "off";
        keybind = [
          "f1=set_font_size:10"
          "f2=set_font_size:14"
          "f3=set_font_size:18"
        ];
      };
    };
    ripgrep.enable = true;
    vesktop.enable = true;
    zsh = {
      enable = true;

      initContent = lib.mkIf pkgs.stdenv.isDarwin ''
        export SDKROOT="${pkgs.apple-sdk.passthru.sdkroot}"
      '';

      autosuggestion.enable = true;
      defaultKeymap = "viins";
      history.share = true;
      historySubstringSearch.enable = true;
      localVariables =
        with lib;
        mkMerge [
          {
            DRACULA_ARROW_ICON = "-> ";
            DRACULA_DISPLAY_CONTEXT = 1;
            DRACULA_DISPLAY_FULL_CWD = 1;
            DRACULA_DISPLAY_TIME = 1;
            DRACULA_TIME_FORMAT = "%-I:%M:%S %p";
            ZSH_THEME = "dracula";
          }
          (mkIf pkgs.stdenv.isLinux { DEBIAN_PREVENT_KEYBOARD_CHANGES = "yes"; })
        ];
      plugins = [
        {
          name = "dracula";
          file = "dracula.zsh-theme";
          src = pkgs.fetchFromGitHub {
            owner = "dracula";
            repo = "zsh";
            rev = "a3e27d47ea2ed1e3b435f44aa71caf71d3219af6";
            hash = "sha256-unPUH3D89gH0j8/kv1Dl+ybR5n8UX0hJ+SuETtgpJOo=";
          };
        }
      ];
      syntaxHighlighting.enable = true;
    };
  };
}
