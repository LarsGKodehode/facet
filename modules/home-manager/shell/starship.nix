{
  config,
  lib,
  home-manager,
  ...
}:

{
  home-manager.users.${config.user}.programs.starship = {
    # Starship Documentation
    # https://starship.rs/config/
    enable = true;
    settings = {
      # Configurations
      command_timeout = 1000;

      # Looks
      add_newline = false;
      format = lib.concatStrings [
        "$hostname"
        "$nix_shell"
        "$kubernetes"
        "$directory"
        "$git_branch"
        "$git_status"
        "$character"
      ];

      # Modules
      character = {
        format = "$symbol ";
        success_symbol = "[λ](green)";
        error_symbol = "[λ](red)";
      };

      hostname = {
        format = "on [$hostname](red) ";
      };

      directory = {
        format = "[$path](blue) ";
        truncate_to_repo = true;
        truncation_length = 10;
      };

      kubernetes = {
        format = " [󱃾 $context\($namespace\)](purple) ";
        disabled = false;
      };

      nix_shell = {
        format = "[$state]($style) ";
        impure_msg = "[❅](red)";
      };

      git_branch = {
        format = "[$symbol$branch]($style)";
        symbol = "";
        truncation_symbol = ".../";
        style = "orange";
      };

      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style)) ";
        ahead = "⇡";
        behind = "⇣";
        diverged = "⇕";
        untracked = "?";
        modified = "!";
        staged = "+";
        style = "yellow";
      };

      palette = "custom";
      palettes.custom = {
        red = config.theme.colors.base08;
        green = config.theme.colors.base0B;
        purple = config.theme.colors.base0E;
        aqua = config.theme.colors.base0C;
        orange = config.theme.colors.base09;
        yellow = config.theme.colors.base0A;
        blue = config.theme.colors.base0D;
      };
    };
  };
}
