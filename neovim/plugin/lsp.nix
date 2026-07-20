{ pkgs, ... }: {
  programs.nixvim = {
    lsp = {
      inlayHints.enable = true;
      servers = {
        lua_ls = {
          enable = true;
          config = {
            completion.showWord = "Disable";
            format = {
              enabled = true;
              defaultConfig = {
                align_call_args = "true";
                align_function_params = "true";
                align_continuous_rect_table_field = "true";
                align_if_branch = "true";
                call_arg_parentheses = "remove";
                indent_style = "space";
                indent_size = "2";
                quote_style = "double";
              };
            };
            hint.enable = true;
            on_init.__raw = ''
              function(client)
                local path = vim.o.packpath:match("([^,]+)") .. "/pack/myNeovimPackages/"

                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                  runtime = {
                    version = "LuaJIT"
                  },
                  workspace = {
                    checkThirdParty = false,
                    library = {
                      vim.env.VIMRUNTIME,
                      path .. "start",
                      path .. "opt",
                    },
                  },
                })
              end
            '';
          };
        };
        nixd.enable = true;
      };
      onAttach = "require'otter'.activate(nil, true, false, nil)";
    };
    extraPackages = with pkgs; [ nixfmt ];

    plugins = {
      blink-cmp =
        let
          winblend = {
            __raw = "vim.g.neovide == true and 15 or vim.o.winblend";
          };
        in
        {
          enable = true;
          settings = {
            completion = {
              documentation = {
                window.border = "rounded";
                inherit winblend;
              };
              menu = {
                border = "rounded";
                draw.treesitter = [ "lsp" ];
                inherit winblend;
              };
              trigger.show_on_backspace = true;
            };
            signature = {
              enabled = true;
              window = {
                border = "rounded";
                inherit winblend;
              };
            };
            keymap = {
              preset = "none";
              "<CR>" = [
                "accept"
                "fallback"
              ];
              "<Up>" = [
                "select_prev"
                "fallback"
              ];
              "<ScrollWheelUp>" = [
                "select_prev"
                "fallback"
              ];
              "<Down>" = [
                "select_next"
                "fallback"
              ];
              "<ScrollWheelDown>" = [
                "select_next"
                "fallback"
              ];
              "<Tab>" = [
                "snippet_forward"
                "fallback"
              ];
              "<S-Tab>" = [
                "snippet_backward"
                "fallback"
              ];
              "<S-CR>" = [
                "show_documentation"
                "hide_documentation"
                "show_signature"
                "show"
              ];
              "<S-BS>" = [
                "hide_documentation"
                "hide"
                "hide_signature"
                "fallback"
              ];
            };
          };
        };
      fidget = {
        enable = true;
        lazyLoad.settings.event = "LspAttach";
        settings.progress = {
          display.done_icon = "✓";
          ignore_done_already = true;
        };
      };
      otter = {
        enable = true;
        lazyLoad.settings.event = "LspAttach";
        autoActivate = false; # handled in `lsp.onAttach`
      };
      rustaceanvim = {
        enable = true;
        settings = {
          server.default_settings.rust-analyzer = {
            cargo.features = "all";
            semanticHighlighting.strings.enable = true;
          };
          tools = {
            enable_clippy = false;
            enable_nextest = false;
            hover_actions.replace_builtin_hover = false;
          };
        };
      };
    };

    extraPlugins = [
      (
        with pkgs;
        vimUtils.buildVimPlugin rec {
          name = "nvim-lsp-endhints";
          src = fetchFromGitHub {
            owner = "chrisgrieser";
            repo = name;
            rev = "cc11482c988ba0e394b3426ae13d0b97e81a508d";
            hash = "sha256-4nIxycCVZSqsjqbaFipCOrQT73bYmdIhC6KZI7q9pIQ=";
          };
        }
      )
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
