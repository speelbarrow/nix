{ pkgs, lib, ... }:
let
  warn = description: action: {
    __raw = ''
      function() 
        require 'lz.n'.trigger_load("dressing")
        local action = ${if action ? __raw then action.__raw else "'${action}'"}

        vim.ui.input(
          {
            prompt = ("You are about to execute the following action: '${description}'. " ..
                     "Are you sure you want to continue? [y/N]"),
          },
          function(input)
            if input and input:lower():sub(1, 1) == "y" then
              if type(action) == "string" then
                vim.cmd(action)
              else
                action()
              end
            end
          end
        )
      end'';
  };
in
{
  programs.nixvim = {
    keymaps =
      let
        mode = [
          "n"
          "i"
          "v"
          "c"
          "t"
        ];
      in
      lib.flatten [
        # copy/paste
        (
          let
            modifier = if pkgs.stdenv.isDarwin then "D" else "C";
            paste = "<${modifier}-v>";
          in
          [
            {
              action = ''"*y'';
              key = "<${modifier}-c>";
              mode = "v";
            }
            {
              action = ''<Cmd>normal "*p<CR>'';
              key = paste;
              mode = [
                "n"
                "i"
                "v"
              ];
            }
            {
              action = ''<C-\><C-n>"*pa'';
              key = paste;
              mode = "t";
            }
            {
              action = ''<Cmd>normal "*P<CR>'';
              key = lib.toUpper paste;
              mode = [
                "n"
                "i"
                "v"
              ];
            }
          ]
        )

        # dap
        (map
          (
            { key, action }:
            {
              action = if action ? __raw then action else "<Cmd>${action}<CR>";
              key = "<M-d>${key}";
              mode = [
                "n"
                "i"
                "v"
              ];
            }
          )
          [
            {
              key = "b";
              action = "DapToggleBreakpoint";
            }
            {
              key = "B";
              action = warn "clear breakpoints" "DapClearBreakpoints";
            }
            {
              key = "c";
              action = "DapContinue";
            }
            {
              key = "i";
              action = "DapStepInto";
            }
            {
              key = "o";
              action = "DapStepOut";
            }
            {
              key = "q";
              action = "DapTerminate";
            }
            {
              key = "s";
              action = "DapStepOver";
            }
            {
              key = "u";
              action.__raw = "function() require'dapui'.toggle() end";
            }
          ]
        )

        # highlight
        {
          action = "<Cmd>noh<CR>";
          key = "<M-h>";
          inherit mode;
        }

        # notify
        {
          action.__raw = "function() require'notify'.dismiss { pending = false, silent = false } end";
          key = "<M-n>";
          inherit mode;
        }

        # terminal
        {
          action.__raw = ''
            function()
                      local command = "sp +terminal"
                      if vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "buftype") == "terminal" then
                        command = "v" .. command
                      end
                      command = "<Cmd>" .. command .. "<CR>"
                      local mode = vim.api.nvim_get_mode().mode
                      if mode ~= "i" and mode ~= "t" then
                        command = command .. "i"
                      end
                      vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes(command, true, false, true),
                        'n',
                        false
                      )
                    end'';
          key = "<M-t>";
          inherit mode;
        }
        {
          action = "<Cmd>terminal<CR>i";
          key = "<M-T>";
          inherit mode;
        }
        {
          action = ''<C-\><C-n>'';
          key = "<Esc>";
          mode = "t";
        }
        (map
          (x: {
            action.__raw = ''
              function()
                        vim.fn.chansend(
                          vim.b.terminal_job_id,
                          vim.api.nvim_replace_termcodes("<${x}>", true, false, true)
                        )
                      end'';
            key = "<S-${x}>";
            mode = "t";
          })
          [
            "Esc"
            "Space"
          ]
        )
      ];

    lsp.keymaps =
      lib.mapAttrsToList
        (key: action: {
          inherit action key;
          mode = [
            "n"
            "i"
            "v"
            "t"
          ];
        })
        {
          "<F1>".__raw = "vim.lsp.buf.hover";
          "<S-F1>" = "<Cmd>checkhealth vim.lsp<CR>";
          "<F2>".__raw = "vim.lsp.buf.rename";
          "<F3>".__raw = "vim.lsp.buf.code_action";

          # TODO: convert these to use telescope pickers
          "<F4>".__raw = "vim.lsp.buf.definition";
          "<S-F4>".__raw = "vim.lsp.buf.type_definition";
          "<F5>".__raw = "vim.lsp.buf.references";
          "<S-F5>".__raw = "vim.lsp.buf.implementation";

          "<F6>".__raw = "vim.diagnostic.open_float";
          "<F7>".__raw = "function() vim.lsp.buf.format { async = true } end";
          # TODO: "<F8>" -> toggle copilot suggestion
          "<F9>".__raw = "function() vim.wo.wrap = not vim.wo.wrap end";
          "<F10>".__raw = "require 'treesitter-context'.toggle";
          "<F11>".__raw = "function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end";
          "<F12>".__raw = "function() vim.wo.spell = not vim.wo.spell end";
        };
  };
}
