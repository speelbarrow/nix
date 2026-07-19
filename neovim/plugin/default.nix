{ ... }: {
  imports = [
    ./lsp
    ./spLauncher
    ./treesitter.nix
  ];
  programs.nixvim.plugins = {
    indent-blankline = {
      enable = true;
      lazyLoad.settings.event = ["BufReadPre" "BufNewFile"];
      settings.scope = {
        show_end = false;
        show_exact_scope = true;
        show_start = false;
      };
    };
    lz-n.enable = true;
    notify = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";

      settings.stages = "slide";
    };
  };
}
