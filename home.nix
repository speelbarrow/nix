{ pkgs, stateVersion, ... }: {
  home = { inherit stateVersion; };
  programs = {
    git = {
      enable = true;
      ignores = if pkgs.stdenv.isDarwin
                then [".DS_Store"]
                else [];
      settings = {
        core.editor = "nvim";
        init.defaultBranch = "main";
        push.autoSetupRemote = true;
        user = {
          name = "Noah Friedman";
          email = "speelbarrow@speely.net";
        };
      };
      signing = {
        key = null;
        signByDefault = true;
      };
    };
    programs.gpg = {
      enable = true;
      publicKeys = [
        { source = ./gmail.pub.asc; }
        { source = ./speely.pub.asc; }
      ];
    };
    ghostty = {
      enable = true;
      package = with pkgs; if stdenv.hostPlatform.isDarwin then ghostty-bin else ghostty;
    };
    neovim.enable = true;
  };
}
