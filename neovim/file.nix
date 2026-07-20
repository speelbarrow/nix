{ pkgs, lib, ... }: let
  indent = count: filetypes: builtins.listToAttrs (map (filetype: {
    name = "after/ftplugin/${filetype}.lua";
    value.localOpts = {
      shiftwidth = count;
      softtabstop = count;
      tabstop = count;
    };
  }) filetypes);
in {
  programs.nixvim = {
    extraFiles = {
      "after/plugin/inspect.lua".source = ./inspect.lua;
      "after/plugin/neovide.lua".text = ''
        if vim.g.neovide then
          vim.g.neovide_cursor_smooth_blink = true
          vim.o.guicursor = ("n-v:block,i-c-ci-ve:ver20,r-cr:hor20,o:hor50,a:blinkwait175-blinkoff500-blinkon500-Cursor/lCursor,sm:block-blinkwait175-blinkoff500-blinkon500")
          vim.g.neovide_underline_stroke_scale = 2
          vim.o.winblend = 15
          vim.o.pumblend = 10
          ${if pkgs.stdenv.isDarwin then "vim.g.neovide_input_macos_option_key_is_meta = 'both'" else ""}
        end
      '';
      "after/ftplugin/nix.lua".text = lib.mkBefore ''
        vim.bo.shiftwidth = 2;
        vim.bo.softtabstop = 2;
        vim.bo.tabstop = 2;
        vim.bo.textwidth = 120;
      '';
    };
    files = lib.mkMerge [
      (indent 2 [ "lua" ])
      (indent 8 [ "sshconfig" ])
    ];
  };
}
