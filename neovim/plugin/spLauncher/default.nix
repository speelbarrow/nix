{
  pkgs,
  lib,
  nixvim,
  ...
}:
{
  programs.nixvim = {
    extraPlugins = [
      (
        with pkgs;
        vimUtils.buildVimPlugin {
          name = "spLauncher";
          src = fetchFromGitHub {
            owner = "speelbarrow";
            repo = "spLauncher.nvim";
            tag = "v0.3.2";
            hash = "sha256-8f9+XbQvZeGaviv8eWHnHV4r3ZQDElSoyNXypVPqXb0=";
          };
        }
      )
    ];
    extraFiles = lib.mkMerge [
      {
        "after/plugin/spLauncher.lua".source = ./init.lua;
      }
      (lib.mapAttrs'
        (name: actionMap: {
          name = "after/ftplugin/${name}.lua";
          value.text =
            "vim.b.spLauncherActionMap = "
            + (nixvim.lib.toLuaObject (removeAttrs actionMap [ "__raw" ]))
            + (if actionMap ? __raw then actionMap.__raw else "");
        })
        {
          run = "nom-shell %";
          Run = "nix-shell %";
          debug = "nom-shell --show-trace %";
          Debug = "nix-shell --show-trace %";
          build = "nom-build --show-trace %";
          Build = "nix-build --show-trace %";
          __raw =
            let
              sudo = if pkgs.stdenv.isDarwin || builtins.pathExists /etc/nixos then "HOME=~root sudo" else "";
            in
            ''

            '';
        }
      )
    ];
  };
}
