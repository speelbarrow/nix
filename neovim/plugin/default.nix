{ ... }: {
  imports = [
    ./dap.nix
    ./lsp.nix
    ./spLauncher
    ./treesitter.nix
  ];
  programs.nixvim = {
    plugins = {
      indent-blankline = {
        enable = true;
        lazyLoad.settings.event = [
          "BufReadPre"
          "BufNewFile"
        ];
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
      project-nvim = {
        enable = true;
        lazyLoad.settings.event = "User DeferredUIEnter";
        settings = {
          patterns = [
            ".git"
            "Cargo.toml"
            "CMakeLists.txt"
            "compile_commands.json"
            "package.json"
            "platformio.ini"
            "pyproject.toml"
            ">.config"
            ">Git"
            ">Scratch"
            "Scratch"
            ">/etc"
          ];
          scope_chdir = "win";
          silent_chdir = false;
        };
      };
    };
  };
}
