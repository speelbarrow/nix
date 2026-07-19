{ pkgs, ... }: {
  home.packages = [
    pkgs.luaPackages.tree-sitter-cli
  ];
  programs.nixvim.plugins = {
    lz-n.enable = true;
    treesitter = {
      enable = true;
      lazyLoad.settings.event = "BufEnter";
      settings = {
        incremental_selection.enable = true;
        indent.enable = true;
        highlight.enable = true;
        textobjects.enable = true;
      };
    };
  };
}
