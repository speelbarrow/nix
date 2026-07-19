{ pkgs, ... }: {
  programs.nixvim = {
    lsp = {
      inlayHints.enable = true;
      servers = {
        nixd.enable = true;
      };
    };
    extraPackages = with pkgs; [ nixfmt ];

    plugins = {
      fidget = {
        enable = true;
        lazyLoad.settings.event = "LspAttach";
        settings.progress.display.done_icon = "✓";
      };
      lsp = {
        enable = true;
        lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
      };
    };

    extraPlugins = [
      (with pkgs; vimUtils.buildVimPlugin rec {
        name = "nvim-lsp-endhints";
        src = fetchFromGitHub {
          owner = "chrisgrieser";
          repo = name;
          rev = "cc11482c988ba0e394b3426ae13d0b97e81a508d";
          hash = "sha256-4nIxycCVZSqsjqbaFipCOrQT73bYmdIhC6KZI7q9pIQ=";
        };
      })
    ];
    plugins.lz-n.plugins = [
      {
        __unkeyed-1 = "nvim-lsp-endhints";
        after.__raw = "function() require'lsp-endhints'.setup() end";
        event = "LspAttach";
      }
    ];
  };
}
