{ ... }:
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

        settings = {
          attach_to_untracked = true;
          preview_config.border = "rounded";
        };
      };
    };
  };
}
