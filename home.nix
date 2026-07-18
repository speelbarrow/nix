{ pkgs, lib, nixvim, stateVersion, ... }: {
  imports = [
    ./neovim
  ];
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
    ripgrep.enable = true;
    vesktop.enable = true;
  };
}
