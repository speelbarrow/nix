{ pkgs, lib, nixvim, ... }: {
  imports = [
    nixvim.homeModules.nixvim
    ./file.nix
    ./keymap.nix
    ./plugin
  ];
  programs = {
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
  };
}
