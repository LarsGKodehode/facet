# Set of shell utilities
{
  config,
  pkgs,
  home-manager,
  ...
}:

{
  home-manager.users.${config.user} = {
    home.packages = [
      pkgs.tree # Directory hierarchy visualizer
      pkgs.jq # JSON processor
      pkgs.htmlq # HTML processor
      pkgs.gawk # awk String processor
      pkgs.ripgrep # grep replacement
      pkgs.sd # Sed

      pkgs.nil # Nix language server
    ];

    programs.fish.shellAbbrs = {
      t = "tree --dirsfirst -C";
    };
  };
}
