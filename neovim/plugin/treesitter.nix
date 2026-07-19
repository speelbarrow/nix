{ pkgs, ... }: {
  home.packages = [
    pkgs.luaPackages.tree-sitter-cli
  ];
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;
      lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
      settings = {
        incremental_selection.enable = true;
        indent.enable = true;
        highlight.enable = true;
        textobjects.enable = true;
      };
    };
    treesitter-context = {
      enable = true;
      settings = {
        mode = "topline";
        multiwindow = true;
        zindex = 100;
      };
    };
    treesitter-textobjects = {
      enable = true;
      settings.lsp_interop.enable = true;
    };
    ts-autotag = {
      enable = true;
      lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
    };
    ts-comments = {
      enable = true;
      lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
    };
  };
}
