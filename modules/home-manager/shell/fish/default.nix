# Fish Shell configuration
# https://fishshell.com/docs/current/index.html

{
  config,
  pkgs,
  ...
}:

{
  users.users.${config.user}.shell = pkgs.fish;
  programs.fish.enable = true;

  home-manager.users.${config.user} = {
    programs.fish = {
      enable = true;

      shellAliases = {};

      shellAbbrs = {
        # Vim
        v = "vim";
      };

      functions = {};

      shellInit = "";
      interactiveShellInit = ''
        fish_vi_key_bindings
        set -g fish_cursor_default block
        set -g fish_cursor_insert line
        set -g fish_cursor_visual block
        set -g fish_cursor_replace_one underscore
      '';
    };

    # Welcome message
    home.sessionVariables.fish_greeting = "";

    # Integrations
    # TODO this type of integration is not too visible
    # outside of this file here, would be nice to make
    # these dependencies a bit clearer
    programs.starship.enableFishIntegration = true;
  };
}
