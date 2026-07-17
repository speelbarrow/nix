{ pkgs, lib, nixvim, stateVersion, ... }: {
  imports = [ nixvim.homeModules.nixvim ];
  home = { 
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nix-output-monitor
    ];
    inherit stateVersion;
  };
  programs = {
    calibre.enable = true;
    git = {
      enable = true;
      ignores = if pkgs.stdenv.isDarwin
                then [".DS_Store"]
                else [];
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
    neovide = {
      enable = true;
      settings = (
        {
          system-native-tabs = true;
          font =
            let
              family = "JetBrainsMono Nerd Font";
            in
            {
              size = 14;
              normal = [
                {
                  inherit family;
                  style = "Normal";
                }
              ];
              bold = [
                {
                  inherit family;
                  style = "ExtraBold";
                }
              ];
              italic = [
                {
                  inherit family;
                  style = "Italic";
                }
              ];
              bold_italic = [
                {
                  inherit family;
                  style = "ExtraBold-Italic";
                }
              ];
            };
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin {
          frame = "transparent";
        }
      );
    };
    nixvim = {	
      enable = true;

      defaultEditor = true;
      vimAlias = true;

      colorschemes.dracula-nvim = {
        enable = true;
        settings = {
          colors.menu = "none";
          transparent_bg = false;
          italic_comment = true;
          show_end_of_buffer = true;
        };
      };

      globals.health.style = "float";
      opts = {
        colorcolumn = "+1";
        expandtab = true;
        mouse = "a";
        number = true;
        shell = "zsh --login"; # required to get all the sourcings just right
        shiftwidth = 4;
        showmode = false;
        signcolumn = "yes";
        softtabstop = 4;
        splitbelow = true;
        splitright = true;
        tabstop = 4;
        textwidth = 100;
      };
    };
    ripgrep.enable = true;
    vesktop.enable = true;
  };
}
