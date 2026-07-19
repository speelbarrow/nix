{ lib, ... }: let
  warn = description: action: {
      __raw = ''function() 
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
in {
  programs.nixvim.keymaps = let
    mode = [ "n" "i" "v" "c" "t" ];
  in lib.flatten [
    # highlight
    {
      action = "<Cmd>noh<CR>";
      key = "<M-h>";
      inherit mode;
    }

    # terminal
    {
      action.__raw = ''function()
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
    (map (x: {
      action.__raw = ''function()
        vim.fn.chansend(
          vim.b.terminal_job_id,
          vim.api.nvim_replace_termcodes("<${x}>", true, false, true)
        )
      end'';
      key = "<S-${x}>";
      mode = "t";
    }) ["Esc" "Space"])
  ];
}
