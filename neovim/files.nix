{ lib, ... }: let
  indent = count: filetypes: builtins.listToAttrs (builtins.map (filetype: {
    name = "after/ftplugin/${filetype}.lua";
    value.localOpts = {
      shiftwidth = count;
      softtabstop = count;
      tabstop = count;
    };
  }) filetypes);
in {
  programs.nixvim = {
    extraFiles."after/plugin/inspect.lua".source = ./inspect.lua;
    files = indent 2 [ "lua" "nix" ];
  };
}
