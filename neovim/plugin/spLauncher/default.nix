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
        "after/plugin/spLauncher.lua".source = ./spLauncher.lua;
      }
      (lib.mapAttrs'
        (name: actionMap: {
          name = "after/ftplugin/${name}.lua";
          value.text =
            "vim.b.spLauncherActionMap = "
            + (nixvim.lib.nixvim.toLuaObject (removeAttrs actionMap [ "__raw" ]))
            + (if actionMap ? __raw then actionMap.__raw else "");
        })
        {
          nix = {
            run = "nom-shell %";
            Run = "nix-shell %";
            debug = "nom-shell --show-trace %";
            Debug = "nix-shell --show-trace %";
            build = "nom-build %";
            Build = "nom-build --show-trace %";
          };
          rust = {
            base = "rustc";
            run.__raw = ''
              function()
                local temp = vim.fn.tempname()
                return "-o " .. temp .. " % && " .. temp
              end
            '';
            debug = {
              handler.__raw = ''
                function()
                  local temp = vim.fn.tempname()
                  return "-g -o " .. temp .. " % && rust-lldb " .. temp
                end
              '';
              config = {
                window = {
                  focus = "insert";
                  persist = false;
                };
              };
            };
            test.__raw = ''
              function()
                local temp = vim.fn.tempname()
                return "--test -o " .. temp .. " % && " .. temp
              end
            '';
            build = "%";
            __raw = ''
              local root = vim.fs.root(0, { 'Cargo.toml' })
              if root ~= nil then
                vim.b.spLauncherActionMap = vim.tbl_deep_extend("force", vim.b.spLauncherActionMap or {}, {
                  base = "cargo",
                  run = function()
                    local stripped = root:gsub("/Cargo%.toml$", "")
                    local path = (vim.fn.expand "%:p"):gsub("^" .. stripped, "")
                    local bin_name, bin_count = path:gsub("^/src/bin/", "")
                    local examples_name, examples_count = path:gsub("^/examples/", "")
                    if bin_count > 0 then
                      return "r --bin=" .. bin_name:gsub("%.rs$", "")
                    elseif examples_count > 0 then
                      return "r --example=" .. examples_name:gsub("%.rs$", "")
                    else
                      return "r"
                    end
                  end,
                  debug = function() vim.cmd "DapNew Debug\\ (+args)" end,
                  test = "t",
                  build = "b",
                  clean = "c",
                  Run = function()
                    return (vim.b.spLauncherActionMap.run() .. " --release")
                  end,
                  Debug = function() vim.cmd "DapNew Debug\\ tests\\ (+args)" end,
                  Test = "t --release",
                  Build = "b --release",
                  Clean = "c --release"
                })
              end
            '';
          };
        }
      )
    ];
  };
}
