{ pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      fugitive = {
        enable = true;
        lazyLoad.settings.event = "User DeferredUIEnter";
      };
      gitsigns = {
        enable = true;
        lazyLoad.settings.event = "User DeferredUIEnter";
        luaConfig.post = "vim.g.yadm_git_gitgutter_enabled = 0";

        settings = {
          attach_to_untracked = true;
          numhl = false;
          preview_config.border = "rounded";
          _on_attach_pre.__raw = ''
            function(bufnr, cb) 
              if vim.bo[bufnr].filetype == "gitcommit" then
                return false
              end
              require 'gitsigns-yadm'.yadm_signs(cb, { bufnr = bufnr }) 
            end
          '';
        };
      };
    };
    extraPlugins =
      with pkgs;
      map vimUtils.buildVimPlugin [
        {
          name = "gitsigns-yadm";
          src = fetchFromGitHub {
            owner = "purarue";
            repo = "gitsigns-yadm.nvim";
            rev = "55575b2af68c0c6c73b1c1f8fe7c54e1e7fe8480";
            hash = "sha256-molMbuW1DD+9xCWLY9IQPxow6c8445tumsoUZYXuitw=";
          };
        }
        {
          name = "yadm-git.vim";
          src = fetchFromGitHub {
            owner = "purarue";
            repo = "yadm-git.vim";
            rev = "90c4229795758c4c4967d0c4d7de8bc4559b5eb7";
            hash = "sha256-Ey1PAkwCPjDm5iSOzmveOH1+GThtw/4aSC16rZSK/ug=";
          };
        }
      ];
  };
}
