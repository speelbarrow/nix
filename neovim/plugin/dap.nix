{ pkgs, ... }: {
  programs.nixvim = {
    plugins =
      let
        configuration = {
          enable = true;
          lazyLoad.settings.lazy = true;
        };
      in
      {
        dap = {
          enable = true;
            lazyLoad.settings = {
              event = "User DeferredUIEnter";
              after.__raw = ''
                function()
                  local lz = require"lz.n"
                  lz.trigger_load("nvim-dap-lldb")
                  lz.trigger_load("nvim-dap-ui")
                end
              '';
            };
        };
        dap-lldb = configuration // {
          settings.codelldb_path = "${pkgs.vscode-extensions.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb/adapter/codelldb";
        };
        dap-ui = configuration;
      };
  };
}
