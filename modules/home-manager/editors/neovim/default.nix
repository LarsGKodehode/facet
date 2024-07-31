{
  config,
  lib,
  home-manager,
  pkgs,
  ...
}:

let
  neovim = import ./package {
    inherit pkgs;
    colors = config.theme.colors;
  };
in
{
  options = {
    editors.neovim = {
      enable = lib.mkEnableOption {
        description = "Enable Neovim";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.editors.neovim.enable) {
    home-manager.users.${config.user} = {
      home.packages = [ neovim ];

      # Set Neovim as the default editor
      home.sessionVariables = {
        EDITOR = "nvim";
      };

      # Set Neovim as the editor for git commits
      programs.git.extraConfig.core.editor = "nvim";

      # Setup shell shortcuts
      programs.fish = {
        shellAliases = {
          vim = "nvim";
        };
        shellAbbrs = {
          v = lib.mkForce "nvim"; # Open neovim
          vl = lib.mkForce "nvim -c 'normal! `0' -c 'bdelete 1'"; # Open neovim and move to top of file
          vll = "nvim -c 'Telescope oldfiles'"; # Open neovim Fuzzyfinder and with recently opened files
        };
      };
    };
  };
}
